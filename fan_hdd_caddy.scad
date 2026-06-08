// ============================================================
// Fan HDD Caddy
// Sits on top of a 140mm fan (fan blows UP). Holds 4 x 3.5"
// HDDs standing on their long edge like books, side by side,
// with air gaps between them so the fan blows up between the
// drives. Low-profile orientation: the 101.6mm drive width is
// vertical to keep total height down.
//
// Drives mount via their SIDE mounting holes (2 per side, the
// "front + back" pattern per SFF-8301 -- the middle hole is
// optional and omitted here).
//
// Assembly order: (1) screw the bare base down onto the fan from
// above; (2) drop the drives in between the side walls; (3) lay
// two clamp bands across the tops and screw down through them
// into the drives' upward-facing side holes.
//
// All key dimensions are variables so the design can be
// retargeted (different fan size, plate thickness, etc.).
// ============================================================

// ---------- Global resolution ----------
$fn = 64;                 // smoothness of curves/holes

// ---------- Fan / base parameters ----------
fan_size        = 140;    // 140mm fan: 140 x 140 mm body
base_thickness  = 3;      // thickness of the base plate (mm)
base_corner_r   = 7;      // rounded corner radius of the base (mm)

// ---------- Fan mounting screw parameters ----------
// Standard 140mm fan mounting holes are 124.5mm apart (7.5mm
// in from each edge). Fans take ~M4 / #6 screws.
fan_screw_spacing = 124.5;  // center-to-center, both X and Y (mm)
fan_screw_d       = 4.5;    // clearance hole for fan screw shaft (mm)
fan_screw_head_d  = 9.0;    // flat-head diameter for countersink (mm)

// ---------- 3.5" HDD parameters (SFF-8301) ----------
drive_length      = 147.0;  // A2 - drive length
drive_width       = 101.6;  // A3 - drive width  (this is VERTICAL here)
drive_height      = 26.10;  // A1 - drive height (thickness)

// Side mounting holes (the 2-hole "front + back" pattern):
side_hole_spacing   = 101.60; // A9 - distance between the 2 side holes
side_hole_from_conn = 28.50;  // A8 - connector end to nearest side hole
side_hole_from_base = 6.35;   // A10 - hole centerline above drive baseplate
// (Drive side holes are 6-32 UNC; kept here as reference for a future
//  mounting method now that bottom screws are ruled out.)

// ---------- Drive layout ----------
num_drives = 4;            // number of drives across the base

// ---------- Side walls ----------
// Two outer walls that bookend the drive row: one against the
// outer face of the first drive, one against the outer face of
// the last drive.
wall_thickness = 3;            // Y thickness of each side wall (mm)
// (Wall height is derived: all walls rise flush with the band tops --
//  see `wall_top` in the derived-values section.)

// ---------- Divider walls (between the drives) ----------
// Walls between adjacent drives. They run the full length of the
// base and the full wall height, giving the clamp bands something
// to land on so the whole caddy prints as one piece.
divider_thickness = 3;         // Y thickness of each divider (mm)

// ---------- Top clamp bands ----------
// Two bands run across the top (Y direction) over the two columns
// of drive side holes. Screws drop through the bands into the
// drives' upward-facing side holes to clamp them down.
band_width      = 20;    // X width of each band (2cm)
band_thickness  = 3;     // Z thickness of each band (mm)
band_screw_d      = 3.8; // clearance hole for 6-32 screw shaft (mm)
band_screw_head_d = 7.0; // flat-head diameter for countersink (mm)

// ---------- Airflow: honeycomb vents ----------
// Hexagonal vent pattern cut through the base plate AND all the walls.
// `hex_size` is the clear opening across the flats of each hole;
// `hex_wall` is the strut thickness left between holes. On the base, a
// solid square is kept around each corner screw and solid strips are
// kept under the walls. On the walls, a solid border is kept around
// every edge.
hex_size         = 10;  // flat-to-flat opening of each hex hole (mm)
hex_wall         = 2;   // strut thickness between holes (mm)
corner_square    = 15;  // solid square around each corner screw (1.5cm)
wall_vent_border = 15;  // solid border around each wall's edges (1.5cm)

// Base reinforcement: keep extra solid material (no honeycomb) here.
base_edge_border    = 5;  // solid border around all 4 base edges (mm)
divider_base_extra  = 2;  // extra solid base on each side of the divider bottoms (mm)

/* [Visualization] */
// Show translucent drive placeholders (GUI preview only; never exported)
show_drives = true;        // [true, false]

// ============================================================
// Derived values
// ============================================================
/* [Hidden] */

// Y center of each drive: evenly distributed across the base.
drive_pitch = fan_size / num_drives;               // center-to-center (Y)
function drive_y(i) = -fan_size/2 + drive_pitch/2 + i*drive_pitch;

// Air gap between adjacent drive faces (for reporting/sanity).
air_gap = drive_pitch - drive_height;

// X positions of the two side-hole columns. Connector end is at -X
// so all drives share the same orientation.
side_hole_x1 = -drive_length/2 + side_hole_from_conn;   // near (connector) column
side_hole_x2 = side_hole_x1 + side_hole_spacing;        // far column

// Y of a drive's side hole: offset in from its baseplate-facing
// (+Y) edge. Same for the up- and down-facing holes.
function drive_hole_y(i) = drive_y(i) + drive_height/2 - side_hole_from_base;

// Z of the band underside = top of the drives.
band_z = base_thickness + drive_width;

// Walls rise all the way up flush with the top of the bands, so the
// whole caddy has a flat top. (The bands interpenetrate the walls
// where they cross, fusing everything into one solid.)
wall_top = band_z + band_thickness;

// ============================================================
// Generic modules
// ============================================================

// Rounded-corner rectangular plate, centered on origin, sitting
// on the XY plane (bottom at z = 0).
module rounded_plate(size, thickness, corner_r) {
    off = size / 2 - corner_r;
    linear_extrude(height = thickness)
        hull()
            for (x = [-off, off], y = [-off, off])
                translate([x, y]) circle(r = corner_r);
}

// A subtractable through-hole with a 90-degree countersink for a
// flat-head screw. `top = true` opens the countersink on the top
// face (+Z), `false` on the bottom face. Centered on the origin.
module countersunk_hole(thickness, shaft_d, head_d, top = true) {
    cs_depth = (head_d - shaft_d) / 2;   // 90-degree included angle
    // through shaft
    translate([0, 0, -1])
        cylinder(h = thickness + 2, d = shaft_d);
    // countersink cone (wide end flush with the chosen face)
    if (top)
        translate([0, 0, thickness - cs_depth])
            cylinder(h = cs_depth + 0.01, d1 = shaft_d, d2 = head_d);
    else
        translate([0, 0, -0.01])
            cylinder(h = cs_depth + 0.01, d1 = head_d, d2 = shaft_d);
}

// ============================================================
// Caddy modules
// ============================================================

// A 2D honeycomb hole field filling a centered (w x h) rectangle. The
// lattice is sized so the struts left between holes are exactly
// `hex_wall` thick; holes are clipped to the rectangle so its border
// is left solid.
module honeycomb_panel_2d(w, h) {
    S      = hex_size + hex_wall;   // center-to-center (all 6 neighbors)
    r_hole = hex_size / sqrt(3);    // circumradius of each hex hole
    dx     = S * sqrt(3) / 2;       // column pitch
    dy     = S;                     // row pitch within a column
    nx = ceil((w/2) / dx) + 1;
    ny = ceil((h/2) / dy) + 1;
    intersection() {
        square([w, h], center = true);
        for (col = [-nx : nx]) {
            x = col * dx;
            y_off = (col % 2 == 0) ? 0 : dy/2;   // stagger alternate columns
            for (row = [-ny : ny])
                translate([x, row*dy + y_off]) circle(r = r_hole, $fn = 6);
        }
    }
}

// Honeycomb through-holes for the base plate. The hex field is inset
// by `base_edge_border` so a solid border is left around all 4 edges.
// `thickness` is the plate thickness to bore through.
module honeycomb_holes(thickness) {
    inner = fan_size - 2 * base_edge_border;
    translate([0, 0, -1])
        linear_extrude(height = thickness + 2)
            honeycomb_panel_2d(inner, inner);
}

// Honeycomb vent cutter for the walls: a hex field in the X-Z plane,
// inset `wall_vent_border` from every wall edge, swept through Y so it
// perforates all five walls identically. Its Z range stays clear of
// the base and the bands, so only the walls get vented.
module wall_honeycomb_cutter() {
    inner_w = fan_size - 2 * wall_vent_border;
    inner_h = (wall_top - base_thickness) - 2 * wall_vent_border;
    zc      = (base_thickness + wall_top) / 2;
    depth   = fan_size + 2;             // sweep through the full Y depth
    translate([0, depth/2, zc])
        rotate([90, 0, 0])
            linear_extrude(height = depth)
                honeycomb_panel_2d(inner_w, inner_h);
}

// Solid keep-out squares centered on each corner screw, so the
// honeycomb does not perforate the material around the fan screws.
module corner_keepouts(thickness) {
    off = fan_screw_spacing / 2;
    for (x = [-off, off], y = [-off, off])
        translate([x, y, thickness/2])
            cube([corner_square, corner_square, thickness + 4], center = true);
}

// Solid keep-out strips under every wall (the two side walls and the
// dividers), so the base stays solid where the walls land on it.
// Footprints mirror the side_walls()/dividers() X/Y placement.
module wall_footprints(thickness) {
    z0 = -2;
    h  = thickness + 4;
    // side walls (flush with the +/-Y edges)
    translate([-fan_size/2, -fan_size/2, z0])
        cube([fan_size, wall_thickness, h]);
    translate([-fan_size/2, fan_size/2 - wall_thickness, z0])
        cube([fan_size, wall_thickness, h]);
    // dividers (centered in each gap), widened by divider_base_extra on
    // each side to reinforce where they join the base
    for (i = [0 : num_drives - 2]) {
        ymid  = drive_y(i) + drive_pitch / 2;
        strip = divider_thickness + 2 * divider_base_extra;
        translate([-fan_size/2, ymid - strip/2, z0])
            cube([fan_size, strip, h]);
    }
}

// The base plate with the honeycomb vents cut in. Material is kept
// solid around the corner screws and under all of the walls.
module perforated_base() {
    difference() {
        rounded_plate(fan_size, base_thickness, base_corner_r);
        // cut the honeycomb everywhere EXCEPT the protected regions
        difference() {
            honeycomb_holes(base_thickness);
            union() {
                corner_keepouts(base_thickness);
                wall_footprints(base_thickness);
            }
        }
    }
}

// The four corner fan-mounting holes, countersunk from the TOP
// (screws drop in from above and thread down into the fan).
module fan_mount_holes() {
    off = fan_screw_spacing / 2;
    for (x = [-off, off], y = [-off, off])
        translate([x, y, 0])
            countersunk_hole(base_thickness, fan_screw_d,
                             fan_screw_head_d, top = true);
}

// The two outer side walls. They rise from the top of the base and
// flank the outer faces of the first and last drives. Clipped to the
// base outline so they follow its rounded corners and stay on the plate.
module side_walls() {
    h = wall_top - base_thickness;   // rise flush with the band tops
    intersection() {
        union() {
            // wall flush against the -Y edge of the base
            translate([-fan_size/2, -fan_size/2, base_thickness])
                cube([fan_size, wall_thickness, h]);
            // wall flush against the +Y edge of the base
            translate([-fan_size/2, fan_size/2 - wall_thickness, base_thickness])
                cube([fan_size, wall_thickness, h]);
        }
        // clip to the base footprint (rounded corners)
        rounded_plate(fan_size, wall_top, base_corner_r);
    }
}

// Divider walls between adjacent drives, centered in each air gap.
// Full length and height like the side walls (clipped to the base
// outline) so the clamp bands land on them.
module dividers() {
    h = wall_top - base_thickness;   // rise flush with the band tops
    intersection() {
        union() {
            for (i = [0 : num_drives - 2]) {
                ymid = drive_y(i) + drive_pitch / 2;   // gap centerline
                translate([-fan_size/2, ymid - divider_thickness/2, base_thickness])
                    cube([fan_size, divider_thickness, h]);
            }
        }
        // clip to the base footprint (rounded corners)
        rounded_plate(fan_size, wall_top, base_corner_r);
    }
}

// One clamp band: a strip running across the top (full Y, clipped to
// the base outline) and centered in X on the column `cx`. It carries
// one countersunk screw hole per drive (countersunk from the top), so
// screws clamp the drives down into their upward-facing side holes.
module clamp_band(cx) {
    difference() {
        intersection() {
            translate([cx - band_width/2, -fan_size/2, band_z])
                cube([band_width, fan_size, band_thickness]);
            // clip to the base footprint so the ends follow the corners
            rounded_plate(fan_size, band_z + band_thickness, base_corner_r);
        }
        for (i = [0 : num_drives - 1])
            translate([cx, drive_hole_y(i), band_z])
                countersunk_hole(band_thickness, band_screw_d,
                                 band_screw_head_d, top = true);
    }
}

// Both clamp bands (separate parts that drop on after the drives).
module clamp_bands() {
    clamp_band(side_hole_x1);
    clamp_band(side_hole_x2);
}

// Translucent ghost drives, for visualizing the layout only
// (not part of the printed geometry).
module ghost_drives() {
    for (i = [0 : num_drives - 1]) {
        yc = drive_y(i);
        // `%` = visualization only; never exported to STL. (Note: this
        // shows as a translucent ghost in OpenSCAD's GUI preview; the
        // CGAL render used for PNGs drops it, so flip to a solid color()
        // temporarily if you need it in a rendered image.)
        %translate([-drive_length/2, yc - drive_height/2, base_thickness])
            cube([drive_length, drive_height, drive_width]);
    }
}

// ============================================================
// Assembly
// ============================================================

// The entire caddy as one printed piece: base + side walls +
// dividers + the two clamp bands, with the screw holes cut out.
module caddy() {
    difference() {
        union() {
            perforated_base();
            side_walls();
            dividers();
            clamp_bands();
        }
        fan_mount_holes();
        wall_honeycomb_cutter();
    }
}

caddy();
if (show_drives) ghost_drives();

// Console report
echo(str("Air gap between drives: ", air_gap, " mm"));
echo(str("Drive overhang per X end: ", (drive_length - fan_size)/2, " mm"));
echo(str("Overall caddy height (flush top): ", wall_top, " mm"));

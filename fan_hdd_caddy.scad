// ============================================================
// Fan HDD Caddy
// Sits on top of a PC case, over a 140mm fan mounted under the
// case top (fan blows UP). Holds 4 x 3.5" HDDs standing on their
// long edge like books, side by side, with air gaps between them
// so the fan blows up between the drives. Low-profile orientation:
// the 101.6mm drive width is vertical to keep total height down.
//
// Drives mount via their SIDE mounting holes (2 per side, the
// "front + back" pattern per SFF-8301 -- the middle hole is
// optional and omitted here).
//
// One printed part: base + side walls + dividers + back wall + two
// top strips. The top strips bridge the drive slots, so print with
// slicer supports under them.
//
// Assembly order: (1) screw the caddy down through the 4 corner
// holes (a long driver reaches them through the relief in each top
// strip), through the case top, into the fan; (2) slide each drive
// in from the open -X (connector) end until it meets the back
// wall; (3) screw down through the top strips into the drives'
// upward-facing side holes.
//
// All key dimensions are variables so the design can be
// retargeted (different fan size, plate thickness, etc.).
// ============================================================

// ---------- Global resolution ----------
$fn = 64;                 // smoothness of curves/holes

// ---------- Fan / base parameters ----------
fan_size        = 140;    // 140mm fan: 140 x 140 mm body
base_thickness  = 3;      // thickness of the base plate (mm)
// Corner radius of the base / walls. Left at 0 (fully square) so the caddy
// fits ANY 140mm fan hole pattern and any case top. Bump this up if the
// mounting surface has rounded corners you want to follow.
base_corner_r   = 0;      // corner radius of base/walls (mm); 0 = square
// 45deg chamfer on the bottom perimeter edge, so the caddy clears the
// chamfered edge of the case top it sits on. Must be < base_thickness and
// <= base_edge_border (so it stays inside the solid base border).
base_chamfer    = 2;      // bottom edge chamfer (mm)

// ---------- Fan mounting screw parameters ----------
// Standard 140mm fan mounting holes are 124.5mm apart (7.5mm
// in from each edge). Fans take ~M4 / #6 screws.
fan_screw_spacing = 124.5;  // center-to-center, both X and Y (mm)
fan_screw_d       = 4.5;    // clearance hole for fan screw shaft (mm)
fan_screw_head_d  = 9.0;    // flat-head diameter for countersink (mm)
// The top strips overhang the corner screws in plan view, and the back wall
// stands right behind the +X pair, so a driver could not reach them from
// above. Each strip gets a round relief above each corner screw this wide,
// so the screw head and the driver shaft pass straight down.
fan_screw_access_d = fan_screw_head_d + 2;  // driver access hole through the strips (mm)

// ---------- 3.5" HDD parameters (SFF-8301) ----------
drive_length      = 147.0;  // A2 - drive length
drive_width       = 101.6;  // A3 - drive width  (this is VERTICAL here)
drive_height      = 26.10;  // A1 - drive height (thickness)

// Side mounting holes (the 2-hole "front + back" pattern):
side_hole_spacing   = 101.60; // A9 - distance between the 2 side holes
side_hole_from_conn = 28.50;  // A8 - connector end to nearest side hole
side_hole_from_base = 6.35;   // A10 - hole centerline above drive baseplate
// (Drive side holes are 6-32 UNC.)

// ---------- Drive layout ----------
num_drives = 4;            // number of drives across the base

// ---------- Side walls ----------
// Two outer walls that bookend the drive row: one against the
// outer face of the first drive, one against the outer face of
// the last drive.
wall_thickness = 2;            // Y thickness of each side wall (mm)
// (Wall height is derived: all walls rise flush with the strip tops --
//  see `wall_top` in the derived-values section.)

// ---------- Back wall ----------
// A wall across the +X end (the non-connector end of the drives). The drives
// slide in from -X and back up to it, so it fixes their X position and ties
// the side walls, dividers, and top strips into one rigid box.
back_wall_thickness = 2;       // X thickness of the back wall (mm)

// ---------- Divider walls (between the drives) ----------
// Walls between adjacent drives. They run the full length of the
// base and the full wall height.
divider_thickness = 2;         // Y thickness of each divider (mm)

// ---------- Top strips ----------
// Two strips run across the top (Y direction) over the two columns of drive
// side holes. They are part of the main piece: they fuse into the wall tops
// and bridge each drive slot (print with supports). Each carries one
// countersunk screw hole per drive to clamp the drives down from above.
band_width      = 20;    // X width of each strip (2cm)
band_thickness  = 2;     // Z thickness of each strip (mm)
band_screw_d      = 3.8; // clearance hole for 6-32 screw shaft (mm)
band_screw_head_d = 7.0; // flat-head diameter for countersink (mm)
band_slot   = 2;         // stretch the strip screw holes into X slots this much
                         // longer, for tolerance in the drive hole position
                         // (the back wall fixes the drives' X datum) (mm)

// Lightening + airflow cutouts: open up the strip between the screw pads and
// the side walls. What stays solid: a pad around each of the 4 screw holes, a
// seat at each Y end (over the side wall), and a rail on each X edge running
// the strip's length. The cutouts over the air gaps double as vents so the
// fan's air exits up through the strip.
band_vent_margin = 3;  // solid strip kept on each X edge (the rails) (mm)
band_pad_margin  = 2;  // extra solid around each screw hole, beyond the head radius (mm)
band_end_seat    = 6;  // solid strip kept at each Y end, over the side wall (mm)
band_vent_r      = 2;  // rounded-corner radius of each cutout (mm)

// ---------- Airflow: honeycomb vents ----------
// Hexagonal vent pattern cut through the base plate AND all the walls.
// The base and the walls are tuned independently:
//   * BASE vents optimize for AIRFLOW (it sits over the fan) ->
//     big holes, thin struts, ~80% open. Flat-top hexes are fine here:
//     base holes are vertical through-holes, so hole shape never bridges.
//   * WALL vents optimize for PRINT TIME (they are NOT for cooling) ->
//     a few large "pointy-top" hexes, so each layer is a handful of long
//     fast moves instead of many tiny ones, while the peaked roofs stay
//     self-supporting.
// On the base, a solid square is kept around each corner screw and solid
// strips under the walls; on the walls, a solid border is kept on every edge.
base_hex_size    = 18;  // base hole flat-to-flat opening (mm) -> ~80% open for airflow
base_hex_wall    = 2;   // base strut thickness between holes (mm)
wall_hex_size    = 30;  // wall hole flat-to-flat opening (mm) -> big & sparse for speed
wall_hex_wall    = 3;   // wall strut thickness between holes (mm) -> few, sturdy struts
corner_square    = 15;  // solid square around each corner screw (1.5cm)
wall_vent_border = 10;  // solid border around each wall's edges (1cm)

// Base reinforcement: keep extra solid material (no honeycomb) here.
base_edge_border    = 5;  // solid border around all 4 base edges (mm)
divider_base_extra  = 2;  // extra solid base on each side of the divider bottoms (mm)

// ---------- Drive fit ----------
drive_z_play = 0.4;// vertical (Z) clearance above the drives: the strip underside
                   // sits this far above the drive top, so a drive always slides
                   // in under the strips
// (No side-to-side retainers: the drives sit loose in their slots, the top
//  screws hold them, and the free space either side is the airflow gap.)

/* [Visualization] */
// Show translucent drive placeholders (GUI preview only; never exported)
show_drives = true;        // [true, false]

// Piece color (preview only; never exported). [R, G, B] 0..1.
color_main   = [0.95, 0.84, 0.20];  // yellow

// ============================================================
// Derived values
// ============================================================
/* [Hidden] */

assert(base_chamfer < base_thickness, "base_chamfer must be smaller than base_thickness");
assert(base_chamfer <= base_edge_border, "base_chamfer must stay inside base_edge_border");

// Y center of each drive: evenly distributed across the base.
drive_pitch = fan_size / num_drives;               // center-to-center (Y)
function drive_y(i) = -fan_size/2 + drive_pitch/2 + i*drive_pitch;

// Air gap between adjacent drive faces (for reporting/sanity).
air_gap = drive_pitch - drive_height;

// X datum: the drives back up to the inner face of the back wall, so their
// connector end (-X) overhangs the base. The two side-hole columns follow.
drive_x_back  = fan_size/2 - back_wall_thickness;      // drive back face rests here
drive_x_front = drive_x_back - drive_length;           // connector end (-X)
side_hole_x1  = drive_x_front + side_hole_from_conn;   // near (connector) column
side_hole_x2  = side_hole_x1 + side_hole_spacing;      // far column

// The driver access relief in each strip must not break into the countersink
// of the neighbouring drive screw (at the +Y end the last drive's screw and
// the corner screw share a Y range). Solid left between the relief edge and
// the countersink edge, per strip:
access_gap_x1 = abs(fan_screw_spacing/2 - abs(side_hole_x1))
                - fan_screw_access_d/2 - (band_slot + band_screw_head_d)/2;
access_gap_x2 = abs(fan_screw_spacing/2 - abs(side_hole_x2))
                - fan_screw_access_d/2 - (band_slot + band_screw_head_d)/2;
assert(access_gap_x1 > 0, "fan_screw_access_d breaks into the drive screw countersink on the -X strip");
assert(access_gap_x2 > 0, "fan_screw_access_d breaks into the drive screw countersink on the +X strip");

// Y of a drive's side hole: offset in from its baseplate-facing
// (+Y) edge. Same for the up- and down-facing holes.
function drive_hole_y(i) = drive_y(i) + drive_height/2 - side_hole_from_base;

// Top of a seated drive, and the strip underside `drive_z_play` above it.
drive_top = base_thickness + drive_width;
band_z    = drive_top + drive_z_play;

// Walls rise all the way up flush with the top of the strips, so the
// whole caddy has a flat top. (The strips interpenetrate the walls
// where they cross, fusing everything into one solid.)
wall_top = band_z + band_thickness;

// ============================================================
// Generic modules
// ============================================================

// Rounded-corner rectangular plate, centered on origin, sitting
// on the XY plane (bottom at z = 0). With corner_r <= 0 it degrades to
// a plain square (a zero-radius circle is degenerate and would empty the
// hull), so the whole design can be squared off for universal fan fit.
module rounded_plate(size, thickness, corner_r) {
    linear_extrude(height = thickness)
        if (corner_r > 0) {
            off = size / 2 - corner_r;
            hull()
                for (x = [-off, off], y = [-off, off])
                    translate([x, y]) circle(r = corner_r);
        } else {
            square(size, center = true);
        }
}

// A subtractable through-hole with a 90-degree countersink for a flat-head
// screw. `top = true` opens the countersink on the top face (+Z), `false` on
// the bottom face. With `slot > 0` the hole (and its countersink) is stretched
// into a rounded slot that much longer in the X direction, for fore/aft play.
// Centered on the origin.
module countersunk_hole(thickness, shaft_d, head_d, top = true, slot = 0) {
    cs_depth = (head_d - shaft_d) / 2;   // 90-degree included angle
    // through shaft (a rounded X slot when slot > 0, else a round hole)
    hull() for (dx = [-slot/2, slot/2])
        translate([dx, 0, -1])
            cylinder(h = thickness + 2, d = shaft_d);
    // countersink cone (wide end flush with the chosen face)
    if (top)
        hull() for (dx = [-slot/2, slot/2])
            translate([dx, 0, thickness - cs_depth])
                cylinder(h = cs_depth + 0.01, d1 = shaft_d, d2 = head_d);
    else
        hull() for (dx = [-slot/2, slot/2])
            translate([dx, 0, -0.01])
                cylinder(h = cs_depth + 0.01, d1 = head_d, d2 = shaft_d);
}

// ============================================================
// Caddy modules
// ============================================================

// A 2D honeycomb hole field filling a centered (w x h) rectangle, sized so the
// struts left between holes are exactly `hw` thick (each hole is `hs` across the
// flats) and clipped to the rectangle so its border stays solid. `pointy = false`
// gives flat-top hexes (used for the base, where the holes go straight through
// so their shape never bridges); `pointy = true` gives pointy-top hexes whose
// peaked roofs stay self-supporting when the panel stands up as a wall vent.
module honeycomb_panel_2d(w, h, hs, hw, pointy = false) {
    S      = hs + hw;            // center-to-center spacing (all 6 neighbors)
    r_hole = hs / sqrt(3);       // circumradius of each hex hole
    pitch  = S * sqrt(3) / 2;    // row/column pitch across the flats
    intersection() {
        square([w, h], center = true);
        if (pointy) {
            // pointy-top hexes: rows stacked in Y (pitch apart), hexes spaced S
            // along X within a row, alternate rows offset S/2 -> peaked roofs.
            ny = ceil((h/2) / pitch) + 1;
            nx = ceil((w/2) / S) + 1;
            for (r = [-ny : ny]) {
                x_off = (r % 2 == 0) ? 0 : S/2;
                for (c = [-nx : nx])
                    translate([c*S + x_off, r*pitch])
                        rotate(30) circle(r = r_hole, $fn = 6);
            }
        } else {
            // flat-top hexes: columns spaced in X (pitch apart), hexes spaced S
            // along Y within a column, alternate columns offset S/2.
            nx = ceil((w/2) / pitch) + 1;
            ny = ceil((h/2) / S) + 1;
            for (c = [-nx : nx]) {
                y_off = (c % 2 == 0) ? 0 : S/2;
                for (r = [-ny : ny])
                    translate([c*pitch, r*S + y_off])
                        circle(r = r_hole, $fn = 6);
            }
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
            honeycomb_panel_2d(inner, inner, base_hex_size, base_hex_wall);
}

// Shared size of the wall vent fields: the wall span between the base top
// and the wall top, inset `wall_vent_border` from every edge.
wall_vent_w  = fan_size - 2 * wall_vent_border;
wall_vent_h  = (wall_top - base_thickness) - 2 * wall_vent_border;
wall_vent_zc = (base_thickness + wall_top) / 2;

// Honeycomb vent cutter for the X-running walls: a hex field in the X-Z
// plane, swept through Y so it perforates both side walls and all dividers
// identically. Its X range stays inside the wall border, so it does not
// reach the back wall; its Z range stays clear of the base and the strips.
module wall_honeycomb_cutter() {
    depth = fan_size + 2;             // sweep through the full Y depth
    translate([0, depth/2, wall_vent_zc])
        rotate([90, 0, 0])
            linear_extrude(height = depth)
                honeycomb_panel_2d(wall_vent_w, wall_vent_h, wall_hex_size, wall_hex_wall, pointy = true);
}

// Honeycomb vent cutter for the back wall: the same hex field stood up in
// the Y-Z plane, swept through the back wall's X range ONLY. Sweeping it any
// further would nick the ends of the dividers where they meet the back wall.
module back_wall_honeycomb_cutter() {
    depth = back_wall_thickness + 2;
    translate([drive_x_back - 1, 0, wall_vent_zc])
        rotate([90, 0, 90])           // map panel (x,y) -> world (Y,Z), extrude along +X
            linear_extrude(height = depth)
                honeycomb_panel_2d(wall_vent_w, wall_vent_h, wall_hex_size, wall_hex_wall, pointy = true);
}

// Solid keep-out squares centered on each corner screw, so the
// honeycomb does not perforate the material around the fan screws.
module corner_keepouts(thickness) {
    off = fan_screw_spacing / 2;
    for (x = [-off, off], y = [-off, off])
        translate([x, y, thickness/2])
            cube([corner_square, corner_square, thickness + 4], center = true);
}

// Solid keep-out strips under every wall (the two side walls, the back wall,
// and the dividers), so the base stays solid where the walls land on it.
// Footprints mirror the side_walls()/back_wall()/dividers() X/Y placement.
module wall_footprints(thickness) {
    z0 = -2;
    h  = thickness + 4;
    // side walls (flush with the +/-Y edges)
    translate([-fan_size/2, -fan_size/2, z0])
        cube([fan_size, wall_thickness, h]);
    translate([-fan_size/2, fan_size/2 - wall_thickness, z0])
        cube([fan_size, wall_thickness, h]);
    // back wall (flush with the +X edge)
    translate([drive_x_back, -fan_size/2, z0])
        cube([back_wall_thickness, fan_size, h]);
    // dividers (centered in each gap), widened by divider_base_extra on
    // each side to reinforce where they join the base
    for (i = [0 : num_drives - 2]) {
        ymid  = drive_y(i) + drive_pitch / 2;
        strip = divider_thickness + 2 * divider_base_extra;
        translate([-fan_size/2, ymid - strip/2, z0])
            cube([fan_size, strip, h]);
    }
}

// The solid base plate body with the bottom perimeter chamfer: the full
// plate from `base_chamfer` up, hulled down to a plate inset `base_chamfer`
// per side at z = 0, giving a 45deg chamfer all the way around.
module base_body() {
    hull() {
        translate([0, 0, base_chamfer])
            rounded_plate(fan_size, base_thickness - base_chamfer, base_corner_r);
        rounded_plate(fan_size - 2 * base_chamfer, 0.01,
                      max(base_corner_r - base_chamfer, 0));
    }
}

// The base plate with the honeycomb vents cut in. Material is kept
// solid around the corner screws and under all of the walls.
module perforated_base() {
    difference() {
        base_body();
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
// (screws drop in from above, pass through the case top, and thread
// into the fan).
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
    h = wall_top - base_thickness;   // rise flush with the strip tops
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
// outline) so the top strips land on them.
module dividers() {
    h = wall_top - base_thickness;   // rise flush with the strip tops
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

// The back wall across the +X end, full Y width and full wall height, with
// its own hex vents. The vents are cut HERE (before the union) so the side
// walls and dividers that meet it fill in any hole they cross, keeping every
// wall-to-wall joint solid.
module back_wall() {
    h = wall_top - base_thickness;
    intersection() {
        difference() {
            translate([drive_x_back, -fan_size/2, base_thickness])
                cube([back_wall_thickness, fan_size, h]);
            back_wall_honeycomb_cutter();
        }
        rounded_plate(fan_size, wall_top, base_corner_r);
    }
}

// One top strip, centered in X on the column `cx`. It spans the full Y width
// (flush with the side wall outer faces) at the wall top, fusing into every
// wall it crosses and bridging each drive slot. It carries one countersunk
// screw hole per drive so the drives are clamped down from above.
module top_strip(cx) {
    inner_y = fan_size/2;
    difference() {
        translate([cx - band_width/2, -inner_y, band_z])
            cube([band_width, 2 * inner_y, band_thickness]);
        for (i = [0 : num_drives - 1])
            translate([cx, drive_hole_y(i), band_z])
                countersunk_hole(band_thickness, band_screw_d,
                                 band_screw_head_d, top = true, slot = band_slot);
        // lightening + airflow cutouts: a rounded slot in every gap between the
        // screw pads (and between each end seat and the outer screw), so only the
        // pads, the end seats, and the two X-edge rails are left solid.
        vw   = band_width - 2 * band_vent_margin;          // X opening width
        pad  = band_screw_head_d / 2 + band_pad_margin;    // Y solid kept around each screw
        scr  = [ for (i = [0 : num_drives - 1]) drive_hole_y(i) ];   // screw Ys (ascending)
        cuts = concat(
            [ [ -inner_y + band_end_seat, scr[0] - pad ] ],                      // -Y end span
            [ for (i = [0 : num_drives - 2]) [ scr[i] + pad, scr[i + 1] - pad ] ], // between screws
            [ [ scr[num_drives - 1] + pad, inner_y - band_end_seat ] ]           // +Y end span
        );
        for (c = cuts)
            if (c[1] - c[0] > 2 * band_vent_r)             // skip slivers too small to round
                translate([cx, (c[0] + c[1]) / 2, band_z - 1])
                    linear_extrude(band_thickness + 2)
                        offset(r = band_vent_r)
                            square([ vw - 2 * band_vent_r,
                                     (c[1] - c[0]) - 2 * band_vent_r ], center = true);
    }
}

// Driver access relief: a round hole through the strip Z range above each
// corner fan screw. Cut from the strips ONLY (walls and pads are untouched),
// so the screw head and driver pass straight down from the top.
module fan_screw_access_cutter() {
    off = fan_screw_spacing / 2;
    for (x = [-off, off], y = [-off, off])
        translate([x, y, band_z - 1])
            cylinder(h = band_thickness + 2, d = fan_screw_access_d);
}

// Both top strips, one over each side-hole column, relieved above the corner
// fan screws and clipped to the base footprint so they follow its corners.
module top_strips() {
    intersection() {
        difference() {
            union() {
                top_strip(side_hole_x1);
                top_strip(side_hole_x2);
            }
            fan_screw_access_cutter();
        }
        rounded_plate(fan_size, wall_top, base_corner_r);
    }
}

// Translucent ghost drives, for visualizing the layout only
// (not part of the printed geometry). Backed up against the back wall.
module ghost_drives() {
    for (i = [0 : num_drives - 1]) {
        yc = drive_y(i);
        // `%` = visualization only; never exported to STL. (Note: this
        // shows as a translucent ghost in OpenSCAD's GUI preview; the
        // CGAL render used for PNGs drops it, so flip to a solid color()
        // temporarily if you need it in a rendered image.)
        %translate([drive_x_front, yc - drive_height/2, base_thickness])
            cube([drive_length, drive_height, drive_width]);
    }
}

// ============================================================
// Assembly
// ============================================================

// The whole caddy: base + side walls + dividers + back wall + top strips,
// with the fan screw holes and the wall vents cut out.
module main_piece() {
    difference() {
        union() {
            perforated_base();
            side_walls();
            dividers();
            back_wall();
            top_strips();
        }
        fan_mount_holes();
        wall_honeycomb_cutter();
    }
}

color(color_main) main_piece();
if (show_drives) ghost_drives();

// Console report
echo(str("Air gap between drives: ", air_gap, " mm"));
echo(str("Free side play, inner slots: ", drive_pitch - divider_thickness - drive_height,
         " mm (slot ", drive_pitch - divider_thickness, " - drive ", drive_height, ")"));
echo(str("Free side play, outer slots: ",
         drive_pitch - wall_thickness - divider_thickness/2 - drive_height,
         " mm (slot ", drive_pitch - wall_thickness - divider_thickness/2,
         " - drive ", drive_height, ")"));
echo(str("Drive overhang at connector (-X) end: ", -fan_size/2 - drive_x_front, " mm"));
echo(str("Overall caddy height (flush top): ", wall_top, " mm"));
echo(str("Bottom edge chamfer: ", base_chamfer, " mm (bottom face ",
         fan_size - 2 * base_chamfer, " mm square)"));
echo(str("Vertical play above drives: ", drive_z_play, " mm (strip underside at z = ", band_z, ")"));
echo(str("Corner screw driver access: ", fan_screw_access_d, " mm hole in the strips; ",
         "solid left to the drive screw countersink: ", access_gap_x1, " mm (-X strip), ",
         access_gap_x2, " mm (+X strip); relief edge sits ",
         drive_x_back - fan_screw_spacing/2 - fan_screw_access_d/2,
         " mm inside the back wall inner face"));

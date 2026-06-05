// ============================================================
//  Dragon Split Monogram — OpenSCAD Script
//  
//  HOW TO USE:
//  1. Export your dragon image as an SVG (Inkscape, Illustrator,
//     or an online PNG-to-SVG tracer like vectorizer.io).
//  2. Split the SVG into two files:
//       - dragon_top.svg    (upper body + wings + horizontal bar)
//       - dragon_bottom.svg (lower tail + claws + horizontal bar)
//  3. Place both SVG files in the same folder as this .scad file.
//  4. Edit the USER SETTINGS below (your text, font, sizes).
//  5. Hit F6 to render, then export as STL.
// ============================================================


// ============================================================
//  USER SETTINGS — edit these
// ============================================================

monogram_text   = "Smith";      // Text to place in the gap
font_name       = "Cinzel:style=Bold"; // Font (must be installed)
                                // Other good choices:
                                //   "MedievalSharp"
                                //   "Uncial Antiqua"
                                //   "IM Fell English:style=Italic"

text_size       = 14;           // Font size in mm
letter_spacing  = 1.2;          // Space between letters (1.0 = normal)

plate_width     = 120;          // Overall width  of the plaque (mm)
plate_height    = 100;          // Overall height of the plaque (mm)
extrude_depth   = 4;            // Total extrusion thickness (mm)
dragon_depth    = 4;            // Depth of dragon geometry (mm)
text_raise      = 1.5;          // How far text stands proud of base (mm)

gap_center_y    = 0;            // Vertical offset of text center (mm)
                                // Negative moves text down, positive up

use_svg         = true;         // true  → import SVG files (recommended)
                                // false → use built-in placeholder geometry

// ============================================================
//  DERIVED VALUES (do not edit unless you know what you're doing)
// ============================================================

half_gap   = text_size * 0.75;  // half the vertical gap reserved for text
bar_thick  = 2;                 // thickness of the horizontal divider bars
bar_y_top  = gap_center_y + half_gap + bar_thick / 2;
bar_y_bot  = gap_center_y - half_gap - bar_thick / 2;


// ============================================================
//  MAIN ASSEMBLY
// ============================================================

union() {

    // --- Dragon geometry (SVG import or placeholder) ----------
    dragon_geometry();

    // --- Text insert -----------------------------------------
    monogram_insert();
}


// ============================================================
//  MODULE: Dragon geometry
// ============================================================

module dragon_geometry() {
    if (use_svg) {
        // ── TOP half (upper body, wings, top bar) ────────────
        translate([0, 0, 0])
        linear_extrude(height = dragon_depth)
            import("dragon_top.svg", center = true);

        // ── BOTTOM half (tail, claws, bottom bar) ─────────────
        translate([0, 0, 0])
        linear_extrude(height = dragon_depth)
            import("dragon_bottom.svg", center = true);

    } else {
        // ── PLACEHOLDER geometry (visible without SVG files) ──
        // Rough stand-in so you can verify layout before SVG work.

        color("black") {
            // Top bar
            translate([0, bar_y_top, 0])
            cube([plate_width * 0.85, bar_thick, dragon_depth], center = true);

            // Bottom bar
            translate([0, bar_y_bot, 0])
            cube([plate_width * 0.85, bar_thick, dragon_depth], center = true);

            // Body block (upper)
            translate([0, bar_y_top + 18, 0])
            cube([30, 30, dragon_depth], center = true);

            // Left wing
            translate([-38, bar_y_top + 12, 0])
            rotate([0, 0, 15])
            cube([40, 20, dragon_depth], center = true);

            // Right wing
            translate([38, bar_y_top + 12, 0])
            rotate([0, 0, -15])
            cube([40, 20, dragon_depth], center = true);

            // Tail block (lower)
            translate([20, bar_y_bot - 12, 0])
            rotate([0, 0, -20])
            cube([50, 12, dragon_depth], center = true);

            // Claw block
            translate([-10, bar_y_bot - 10, 0])
            cube([18, 14, dragon_depth], center = true);
        }
    }
}


// ============================================================
//  MODULE: Monogram text insert
// ============================================================

module monogram_insert() {
    color("dimgray")
    translate([0, gap_center_y, dragon_depth - 0.01])   // sit on top of base
    linear_extrude(height = text_raise)
        text(
            monogram_text,
            size     = text_size,
            font     = font_name,
            halign   = "center",
            valign   = "center",
            spacing  = letter_spacing
        );
}


// ============================================================
//  OPTIONAL: Backing plate (uncomment if you want a solid base)
// ============================================================

// translate([0, 0, -1])
// color("white", 0.3)
// cube([plate_width, plate_height, 1], center = true);


// ============================================================
//  NOTES
// ============================================================
//
//  SVG EXPORT TIPS:
//  • In Inkscape: File → Save As → Plain SVG
//  • Make sure the SVG uses a viewBox with consistent units.
//  • Scale the SVG so its width ≈ plate_width mm before importing.
//  • OpenSCAD reads SVG in mm; 1 SVG user unit = 1 mm by default.
//
//  FONT TIPS:
//  • OpenSCAD uses fonts installed on your system.
//  • Download free medieval fonts from fonts.google.com and install them.
//  • Run  Help → Font List  inside OpenSCAD to see available fonts.
//
//  RENDERING:
//  • Press F5 for fast preview (CSG, no CGAL).
//  • Press F6 for full render before STL export.
//  • File → Export → Export as STL
//
// ============================================================

$fn=256;

motor_rad = 13.5;
motor_dia = motor_rad * 2;
motor_len = 59;

arduino_len = 101.5;
arduino_wid = 53.3;

driver_len = 43;
driver_wid = 43;

base_ht = 2;
padding = 2;

axle_offset = motor_rad + padding;
x_offset = 32;

y_dim = arduino_len + (2 * motor_dia) + 24;
x_dim = motor_len + x_offset;
z_dim = motor_dia + base_ht;

module axle(rotation = 0) {
    rotate([0, rotation, 0]) {
        difference() {
            base_cyl_ht = 8;
            axle_cyl_ht = 9;
            top_cyl_ht = 2;
            union() {
                cylinder(r=4, h=base_cyl_ht);
                translate([0, 0, base_cyl_ht])
                    cylinder(r=2.4, h=axle_cyl_ht);
                translate([0, 0, base_cyl_ht + axle_cyl_ht])
                    cylinder(r=3, h=top_cyl_ht);
            }
            
            slot_width = 1.4;
            slot_length = 8;
            slot_height = 4;
            slot_z = base_cyl_ht + axle_cyl_ht + top_cyl_ht - slot_height;
            
            rotate([0, 0, 90])
                translate([- slot_width / 2, - slot_length / 2, slot_z])
                    cube([slot_width, slot_length, slot_height + 1]);
        }
    }
}

module motor_housing(rotation = 0) {
    padding = 2;
    width = motor_dia + padding * 2;
    length = x_dim;
    height = motor_dia / 2 + padding;
    rotate([0, 0, rotation]) {
        translate([- width / 2, 0, 0]) {
            difference() {
                union() {
                    translate([width / 2,  0, 0]) 
                        cube([width / 2, length, height]);
                    rotate([-90,0,0])
                        translate([width / 2, - width / 2, 0]) 
                            cylinder(r = width / 2, h = length);
                }
                rotate([-90,0,0])
                    translate([width / 2, - width / 2, - 1])
                        cylinder(r = motor_rad, h = length + 2);
                
                translate([(width / 2),  padding, 2])
                    cube([(width / 2) + 1, x_offset, height]);
            }
        }
    }
}

module axle_housing(rotation = 0) {
    rotate([0, 90, rotation]) {
        height = 5;
        difference() {
            union() {
            cylinder(d=motor_dia + 4, h=height);
            translate([0, 0, -height])
                cylinder(r=4, h=5);
            }
            translate([0, 0, 1])
                cylinder(d=motor_dia, h=height);
            translate([0, 0, -6])
                cylinder(r=2.2, h=8);
            translate([0, 0, - 2])
                cylinder(r=3.3, h=4);
        }
    }
}

module box(x, y, z) {
    hull()
    {
        translate([x, y - axle_offset, motor_rad + padding])
            rotate([0, -90, 0])
                cylinder(d=motor_dia + 4, h=x);
        translate([x, axle_offset, motor_rad + padding])
            rotate([0, -90, 0])
                cylinder(d=motor_dia + 4, h=x);  
    }
}

module shell() {
    difference() {
        
        union() {
            box(x_dim, y_dim, z_dim);
            
            cube([x_dim, motor_rad + padding, motor_rad + padding]);

            translate([0, y_dim - axle_offset, 0])
                cube([x_dim, motor_rad + padding, motor_rad + padding]);
            
            translate([x_dim, axle_offset, motor_rad + base_ht])
                axle(rotation = 90);

            translate([0, y_dim - axle_offset, motor_rad + base_ht])
                axle(rotation = -90);  
        }
        
        translate([padding, padding, padding])
            box(x_dim - (2 * padding), y_dim - (2 * padding), z_dim);
        
        translate([x_dim + padding, y_dim - axle_offset, motor_rad + base_ht])
            rotate([0, -90, 0])
                cylinder(d=motor_dia, h=x_dim);
        
        translate([0 - padding, axle_offset, motor_rad + base_ht])
            rotate([0, 90, 0])
                cylinder(d=motor_dia, h=x_dim);        
    }
    width = motor_len + padding + 5;
    
    translate([x_dim + padding + 1, y_dim - axle_offset, motor_rad + base_ht])
        axle_housing(rotation = 180);
    
    translate([0 - padding - 1, axle_offset, motor_rad + base_ht])
        axle_housing(rotation = 0);

    translate([x_dim, axle_offset, 0])
        motor_housing(90);
    
    translate([0, y_dim - axle_offset, 0])
        motor_housing(-90);
} 

module construct() {
    difference() {
        shell();
        
        translate([padding, axle_offset, z_dim / 2])
            cube([x_dim - (2 * padding), y_dim - 2 * axle_offset, z_dim / 2]);
        
        translate([padding, 0, 3 * (z_dim / 4) + 2])
            cube([x_dim - (2 * padding), y_dim , z_dim / 2]);

    }
}


mirror([1,0,0])
construct();
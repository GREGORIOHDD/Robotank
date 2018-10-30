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

module top() {
    translate([padding, 0, 0])
    
    difference() {
        union() {
            difference()
            {
                box(x_dim - (2 * padding), y_dim, z_dim);

                translate([- padding - 1, axle_offset, 0])
                    cube([x_dim + padding, y_dim - motor_dia - padding * 2, z_dim]);
                
                translate([- padding - 1, 0, - 1])
                    cube([x_dim + padding, y_dim, 3 * (z_dim / 4) + 2 + 1]);

                
                width = 10;
                length = y_dim / 2;
                translate([3 * (x_dim / 4) + width / 2 - padding, y_dim / 2 - length / 2, z_dim - padding])
                    cube([width, length, z_dim / 2]);
                
                translate([padding + width / 2, y_dim / 2 - length / 2, z_dim - padding])
                    cube([width, length, z_dim / 2]);
            }


        }
        translate([- padding - 1, axle_offset, motor_rad + padding])
            rotate([0, 90, 0])
                cylinder(r=motor_rad, h=x_dim + padding);
        
        translate([- padding - 1, y_dim - axle_offset, motor_rad + padding])
            rotate([0, 90, 0])
                cylinder(r=motor_rad, h=x_dim + padding);
    }
    
    length = x_dim - padding - x_offset;
        
    top_brace();
    
    translate([x_dim, y_dim, 0])
        rotate([0, 0, 180])
            top_brace();   
}

module top_brace() {
    angle_size = 12;
    angle_x = x_offset + padding;
    angle_y = y_dim - motor_rad - axle_offset - angle_size / 2 + padding;
    angle_z = z_dim - padding - angle_size / 2;

    translate([x_offset + padding, y_dim - motor_rad - axle_offset - 4, padding])
        cube([x_dim - x_offset - (padding * 2), padding, z_dim - padding]);
    
    difference() {
        translate([angle_x, angle_y + padding / 2, angle_z])
           rotate([45, 0, 0])
                cube([x_dim - x_offset - (padding * 2), angle_size, angle_size]);
        
        translate([angle_x - 1, angle_y, angle_z])
            cube([x_dim - x_offset - padding, angle_size, angle_size * 2]);
        
        translate([angle_x - 1 , angle_y - angle_size + padding / 2, z_dim + padding / 2])
            cube([x_dim - x_offset - padding, angle_size, angle_size]);

    }
}



mirror([1,0,0])
top();

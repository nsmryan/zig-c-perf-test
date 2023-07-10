const std = @import("std");
const rand = std.rand;
const Random = std.rand.Random;
const RndGen = std.rand.DefaultPrng;

pub fn main() !void {
    var allocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(allocator);
    if (args.len < 4) {
        std.debug.panic("requires two arguments: iterations seed algorithm, received only {}", .{args.len - 1});
    }
    const iterations: u64 = std.fmt.parseInt(u64, args[1], 10) catch unreachable;
    const seed: u64 = std.fmt.parseInt(u64, args[2], 10) catch unreachable;
    const algorithm: u64 = std.fmt.parseInt(u64, args[3], 10) catch unreachable;

    var rng = RndGen.init(seed);
    var random = rng.random();

    var input: [1000000]u8 = undefined;
    var index: usize = 0;
    while (index < input.len) : (index += 1) {
        if (random.boolean()) {
            input[index] = 's';
        } else {
            input[index] = 'p';
        }
    }

    var result: isize = 0;
    var iter: u64 = 0;

    if (algorithm == 0) {
        while (iter < iterations) : (iter += 1) {
            result += run_switches_0(input[0..]);
        }
    } else if (algorithm == 1) {
        while (iter < iterations) : (iter += 1) {
            result += run_switches_1(input[0..]);
        }
    } else if (algorithm == 2) {
        while (iter < iterations) : (iter += 1) {
            result += run_switches_2(input[0..]);
        }
    } else if (algorithm == 3) {
        while (iter < iterations) : (iter += 1) {
            result += run_switches_3(input[0..]);
        }
    } else if (algorithm == 4) {
        while (iter < iterations) : (iter += 1) {
            result += run_switches_4(input[0..]);
        }
    }
    std.debug.print("{}\n", .{result});
}

fn run_switches_0(input: [*]u8) isize {
    var input_ptr = input;
    var res: isize = 0;
    while (true) {
        const c: u8 = input_ptr[0];
        input_ptr += 1;
        switch (c) {
            0 => return res,
            's' => res += 1,
            'p' => res -= 1,
            else => {},
        }
    }
}

fn run_switches_1(input: [*]u8) isize {
    var input_ptr = input;
    var res: isize = 0;
    while (true) {
        const c: u8 = input_ptr[0];

        if (c == 0) {
            return res;
        }

        input_ptr += 1;

        if (c == 'p') {
            res += 1;
        }
        if (c == 's') {
            res -= 1;
        }
    }
}

fn run_switches_2(input: [*]u8) isize {
    var input_ptr = input;
    var res: isize = 0;
    while (true) {
        const c: u8 = input_ptr[0];

        if (c == 0) {
            return res;
        }

        input_ptr += 1;
        var n: isize = 0;
        if (c == 'p') {
            n = 1;
        }
        if (c == 's') {
            n = -1;
        }
        res += n;
    }
}

var table = init: {
    var initial_value: [256]isize = undefined;
    initial_value['s'] = 1;
    initial_value['p'] = -1;
    break :init initial_value;
};

fn run_switches_3(input: [*]u8) isize {
    var input_ptr = input;
    var res: isize = 0;
    while (true) {
        const c: u8 = input_ptr[0];
        input_ptr += 1;
        if (c == 0) return res;
        res += table[c];
    }
}

fn run_switches_4(input: [*]u8) isize {
    var input_ptr = input;
    var res: isize = 0;
    while (true) {
        const c: u8 = input_ptr[0];

        if (c == 0) {
            return res;
        }

        input_ptr += 1;
        var p = @intFromBool(c == 'p');
        var s = -1 * @as(isize, @intFromBool(c == 's'));
        res += p + s;
    }
}

const std = @import("std");
const uuid = @import("uuid-zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    var stderr_buffer: [1024]u8 = undefined;
    var stderr_writer = std.Io.File.stderr().writer(io, &stderr_buffer);
    const stderr = &stderr_writer.interface;

    var args = std.process.Args.Iterator.init(init.minimal.args);

    const arg0 = args.next() orelse "bench";
    const count_str = args.next() orelse {
        try stderr.print("usage: {s} <nr-of-UUIDs> <version>\n", .{arg0});
        return;
    };
    const version_str = args.next() orelse {
        try stderr.print("usage: {s} <nr-of-UUIDs> <version>\n", .{arg0});
        return;
    };

    const iterations = try std.fmt.parseInt(usize, count_str, 10);

    var i: usize = 0;
    var duration: u64 = 0;
    switch (if (version_str.len < 2) version_str[0] else version_str[1]) {
        '4' => {
            const start = std.Io.Timestamp.now(io, .awake);

            while (i < iterations) : (i += 1) {
                const id = uuid.v4.new(io);
                std.mem.doNotOptimizeAway(id);
            }

            duration = @intCast(start.durationTo(std.Io.Timestamp.now(io, .awake)).nanoseconds);
        },
        '7' => {
            const start = std.Io.Timestamp.now(io, .awake);

            while (i < iterations) : (i += 1) {
                const id = uuid.v7.new(io);
                std.mem.doNotOptimizeAway(id);
            }

            duration = @intCast(start.durationTo(std.Io.Timestamp.now(io, .awake)).nanoseconds);
        },
        else => {
            try stderr.print("unsupported version!\nversions: v4, v7\nusage: {s} <nr-of-UUIDs> <version>\n", .{arg0});
            return;
        },
    }

    try stdout.print("{s}: {d} UUIDs in ", .{ version_str, iterations });
    try stdout.printDurationUnsigned(duration);
    try stdout.print("\n", .{});

    try stdout.flush();
    try stderr.flush();
}

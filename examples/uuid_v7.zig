const std = @import("std");
const uuid = @import("uuid-zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const id1 = uuid.v7.new(io);
    const id2 = uuid.v7.new(io);

    const urn1 = uuid.urn.serialize(id1);
    const urn2 = uuid.urn.serialize(id2);

    try stdout.print("v7: {s}\n", .{urn1});
    try stdout.print("v7: {s}\n", .{urn2});
    try stdout.flush();
}

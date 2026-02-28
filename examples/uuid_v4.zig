const std = @import("std");
const uuid = @import("uuid-zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.Io.File.stdout().writer(io, &stdout_buffer);
    const stdout = &stdout_writer.interface;

    const id = uuid.v4.new(io);

    const urn = uuid.urn.serialize(id);

    try stdout.print("v4: {s}\n", .{&urn});
    try stdout.flush();
}

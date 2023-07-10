const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{ .name = "zig-perf-vs-c-test", .root_source_file = .{ .path = "src/main.zig" }, .target = target, .optimize = optimize });
    b.installArtifact(exe);

    const run = b.step("run", "run benchmarking");
    const run_artifact = b.addRunArtifact(exe);
    run_artifact.step.dependOn(b.getInstallStep());
    run.dependOn(&run_artifact.step);
}

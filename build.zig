const std = @import("std");
const statically = @import("statically");

const src = &.{
    "src/api.c",
    "src/dumper.c",
    "src/emitter.c",
    "src/loader.c",
    "src/parser.c",
    "src/reader.c",
    "src/scanner.c",
    "src/writer.c",
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    _ = statically.option(b);
    statically.log("libyaml");

    const options = .{
        .name = "yaml",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    };

    const lib = statically.library(b, options, options);

    const c_flags = &.{
        "-DYAML_VERSION_MAJOR=0",
        "-DYAML_VERSION_MINOR=2",
        "-DYAML_VERSION_PATCH=5",
        "-DYAML_VERSION_STRING=\"0.2.5-zigify\"",
    };

    lib.addCSourceFiles(.{ .files = src, .flags = c_flags });
    lib.addIncludePath(b.path("src"));
    lib.addIncludePath(b.path("include"));
    lib.installHeader(b.path("include/yaml.h"), "yaml.h");

    b.installArtifact(lib);
}

load("//:compile.bzl", "proto_compile")
load("//:plugin.bzl", "proto_plugin")

def go_proto_compile(**kwargs):
    # If importpath specified, declare a custom plugin that should correctly
    # predict the output location.
    importpath = kwargs.get("importpath")
    if importpath and not kwargs.get("plugins"):
        name_plugin = kwargs.get("name") + "_plugin"
        proto_plugin(
            name = name_plugin,
            outputs = ["{package}/%s/{basename}.pb.go" % importpath],
            tool = "@com_github_golang_protobuf//protoc-gen-go",
        )
        kwargs["plugins"] = [name_plugin]
        kwargs.pop("importpath")

    # Define the default plugin if still not defined
    if not kwargs.get("plugins"):
        kwargs["plugins"] = [Label("//go:go")]

    proto_compile(
        **kwargs
    )

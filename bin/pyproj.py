#!/usr/bin/env python3


from __future__ import absolute_import, division, print_function


from uuid import getnode as get_mac
import hashlib
import time
import os
import pprint


def uid_generator():
    digest = hashlib.blake2b(b"%012X"%get_mac(), digest_size=4)
    machine_code = digest.hexdigest().upper()
    serial = 0 
    last_second = 0
    while True:
        second = int(time.time())
        if last_second != second:
            last_second = second
            serial = 0
        else:
            serial += 1
        uid = machine_code + ("%08X" % second) + ("%08X" % serial)
        yield uid
uid_generator = uid_generator()

def new_uid():
    return next(uid_generator)


class XcodeObject(object):
    def __init__(self, *args, **kw):
        super(XcodeObject, self).__init__()
        self._uid = new_uid()

    @property
    def uid(self):
        return self._uid

    def __str__(self):
        return self.uid


class FsItem(XcodeObject):
    def __init__(self, name, path):
        super(FsItem, self).__init__(name, path)
        self.name = name
        self.path = path

    @property
    def referenced_in_group(self):
        return "%s /* %s */" % (self.uid, self.name)


class File(FsItem):
    _type_map = {
        ".h": "sourcecode.c.h",
    }

    @property
    def file_type(self):
        return self._type_map[os.path.splitext(self.name)[-1]]

    def __str__(self):
        return (
            "\t\t%s /* %s */ = {"
            "isa = PBXFileReference; "
            "lastKnownFileType = %s; "
            "path = %s; "
            "sourceTree = \"<group>\"; };" % (
                self.uid, self.name, self.file_type, self.name))


class Group(FsItem):
    def __init__(self, name, path, children=None):
        super(Group, self).__init__(name, path)
        self.children = children if children else list()

    def __str__(self):
        lines = list()
        if self.name:
            lines.append("\t\t%s /* %s */ = {" % (self.uid, self.name))
        else:
            lines.append("\t\t%s = {" % self.uid)
        lines.append("\t\t\tisa = PBXGroup;")
        lines.append("\t\t\tchildren = (")
        for child in self.children:
            lines.append("\t\t\t\t%s," % child.referenced_in_group)
        lines.append("\t\t\t);")
        if self.name:
            lines.append("\t\t\tname = %s;" % self.name)
        if self.path:
            lines.append("\t\t\tpath = %s;" % self.path)
        lines.append("\t\t\tsourceTree = \"<group>\";")
        lines.append("\t\t};")
        return "\n".join(lines)

    def all_groups(self):
        groups = list()
        for child in self.children:
            try:
                subgroups = child.all_groups()
            except AttributeError:
                continue
            groups.extend(it for it in subgroups if isinstance(it, Group))
        groups.insert(0, self)
        return groups

    def all_files(self):
        files = [it for it in self.children if isinstance(it, File)]
        for child in self.children:
            try:
                subfiles = child.all_files()
            except AttributeError:
                continue
            files.extend(it for it in subfiles if isinstance(it, File))
        return files


def scan_directory(directory, chroot=None, extensions=None):
    if extensions is None:
        extensions = list()
    if chroot is None:
        chroot = directory
    folders = {directory: Group(directory.split(os.sep)[-1], chroot)}
    for root, dnames, fnames in os.walk(directory):
        tail = root.split(os.sep)[-1]
        for dname in dnames:
            parent = folders.setdefault(root, Group(tail, tail))
            child = Group(dname, dname)
            parent.children.append(child)
        for fname in fnames:
            main, ext = os.path.splitext(fname)
            if ext in extensions:
                parent = folders.setdefault(root, Group(tail, tail))
                child = File(fname, os.path.join(root, fname))
                parent.children.append(child)
    return folders[directory]


def generate_group():
    include = scan_directory("python/Include", "../../python/Include", [".h"])
    top = Group(None, None, [include])
    return top


class BuildConfig(XcodeObject):
    def __init__(self, name):
        super(BuildConfig, self).__init__()
        self.name = name

    def __str__(self):
        lines = list()
        lines.append("\t\t%s /* %s */ = {" % (self.uid, self.name))
        lines.append("\t\t\tisa = XCBuildConfiguration;")
        lines.append("\t\t\tbuildSettings = {")
        lines.append("\t\t\t};")
        lines.append("\t\t\tname = %s;" % self.name)
        lines.append("\t\t};")
        return "\n".join(lines)


class ConfigList(XcodeObject):
    def __init__(self, configs):
        super(ConfigList, self).__init__()
        self.configs = configs if configs else list()

    def __str__(self):
        lines = list()

        lines.append("/* Begin XCBuildConfiguration section */")
        for config in self.configs:
            lines.append(str(config))
        lines.append("/* End XCBuildConfiguration section */")
        lines.append("")

        lines.append("/* Begin XCConfigurationList section */")
        lines.append("\t\t%s /* Build configuration list for PBXProject */ = {"
                     % self.uid)
        lines.append("\t\t\tisa = XCConfigurationList;")
        lines.append("\t\t\tbuildConfigurations = (")
        for config in self.configs:
            lines.append("\t\t\t\t%s /* %s */," % (config.uid, config.name))
        lines.append("\t\t\t);")
        lines.append("\t\t\tdefaultConfigurationIsVisible = 0;")
        lines.append("\t\t\tdefaultConfigurationName = %s;" %
                     self.configs[-1].name)
        lines.append("\t\t};")
        lines.append("/* End XCConfigurationList section */")

        return "\n".join(lines)


class PBXProject(XcodeObject):
    def __init__(self, config_list, group):
        super(PBXProject, self).__init__()
        self.config_list = config_list
        self.group = group

    def __str__(self):
        lines = list()

        lines.append("/* Begin PBXFileReference section */")
        for xfobj in self.group.all_files():
            lines.append(str(xfobj))
        lines.append("/* End PBXFileReference section */")
        lines.append("")

        lines.append("/* Begin PBXGroup section */")
        for group in self.group.all_groups():
            lines.append(str(group))
        lines.append("/* End PBXGroup section */")
        lines.append("")

        lines.append("/* Begin PBXProject section */")
        lines.append("\t\t%s /* Project object */ = {" % self.uid)
        lines.append("\t\t\tisa = PBXProject;")
        lines.append("\t\t\tattributes = {")
        lines.append("\t\t\t\tLastUpgradeCheck = 0830;")
        lines.append("\t\t\t};")
        lines.append("\t\t\tbuildConfigurationList = %s "
                     "/* Build configuration list for PBXProject */;" %
                     self.config_list.uid)
        lines.append("\t\t\tcompatibilityVersion = \"Xcode 3.2\";")
        lines.append("\t\t\tdevelopmentRegion = English;")
        lines.append("\t\t\thasScannedForEncodings = 0;")
        lines.append("\t\t\tknownRegions = (")
        lines.append("\t\t\t\ten,")
        lines.append("\t\t\t);")
        lines.append("\t\t\tmainGroup = %s;" % self.group.uid)
        lines.append("\t\t\tprojectDirPath = \"\";")
        lines.append("\t\t\tprojectRoot = \"\";")
        lines.append("\t\t\ttargets = (")
        lines.append("\t\t\t);")
        lines.append("\t\t};")
        lines.append("/* End PBXProject section */")
        lines.append("")

        lines.append(str(self.config_list))

        return "\n".join(lines)


class ProjFile(object):
    def __init__(self, project):
        self.project = project

    def __str__(self):
        lines = list()
        lines.append("// !$*UTF8*$!")
        lines.append("{")
        lines.append("\tarchiveVersion = 1;")
        lines.append("\tclasses = {")
        lines.append("\t};")
        lines.append("\tobjectVersion = 46;")
        lines.append("\tobjects = {")
        lines.append("")
        lines.append(str(self.project))
        lines.append("\t};")
        lines.append("\trootObject = %s /* Project object */;" %
                     self.project.uid)
        lines.append("}")
        return "\n".join(lines)


config_list = ConfigList([
    BuildConfig("Debug"),
    BuildConfig("Release"),
])
group = generate_group()

with open("tmp/try1/try1.xcodeproj/project.pbxproj", "w") as fobj:
    fobj.write(str(ProjFile(PBXProject(config_list, group))))

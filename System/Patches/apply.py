import os
import subprocess
import xml.etree.ElementTree as ET
import sys


# 解析 manifests 中的 project 字段信息
def parse_manifests(manifests_dir):
    project = {}
    for subdir, dirs, files in os.walk(manifests_dir):
        for file in files:
            if file.endswith('.xml'):
                file_path = os.path.join(subdir, file)
                tree = ET.parse(file_path)
                root = tree.getroot()
                for child in root:
                    if child.tag == 'project':
                        project[child.attrib['name'].split(
                            '/')[-1]] = child.attrib['path']
    return project


if __name__ == '__main__':
    root_dir = sys.argv[1]
    patch_search_dir = sys.argv[2]
    manifests_dir = os.path.join(root_dir, ".repo", "manifests")

    project = parse_manifests(manifests_dir)
    for item in os.scandir(patch_search_dir):
        if item.is_dir():
            print(item.path, item.name, project[item.name])
            apply_dir = os.path.join(root_dir, project[item.name])
            patch_dir = os.path.join(patch_search_dir, item.name)
            # 改变当前工作目录
            os.chdir(apply_dir)
            # 执行命令并获取输出
            try:
                output = subprocess.check_output(
                    "git am %s/*.patch" % (patch_dir), shell=True, stderr=subprocess.STDOUT)
            except subprocess.CalledProcessError as e:
                output = e.output
            finally:
                # 输出命令的输出
                print(output.decode())

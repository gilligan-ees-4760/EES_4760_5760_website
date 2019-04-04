#!/usr/bin/python3
import os
import sys
import subprocess
import re
import platform

system = platform.system().lower()
if (system == 'windows'):
    decktape = ['old_decktape.bat',]
elif (system == 'linux'):
    # decktape = 'decktape'
    decktape = ['~/decktape/bin/phantomjs','~/decktape/decktape.js']
    decktape = list(map(os.path.expanduser, decktape))

# subprocess.call(decktape + ['-h',], shell=True)

# args = ['reveal', '-s', '1920x1080']
# args = ['reveal', '-s', '1280x1024']
args = ['reveal', '-s', '1440x900']

lecture_template = "EES_3310_5310_Class_%02d_Slides.pdf"
url_template = "http://localhost:8000/Slides/Class_%02d/"
classnum_expr = re.compile('.*_(?P<class_num>[0-9]+)$')


def run_decktape(path):
  class_number = None
  cwd = os.getcwd()
  if path is None or path == "":
    path = cwd
    print("Setting empty path to \"%s\"" % path)
  if os.path.isdir(path):
    m = classnum_expr.match(path)
    if m:
      class_number = int(m.group("class_num"))
  elif re.match("^[0-9]+$", path):
    class_number = int(path)
  if class_number is None:
    print("Can't figure out which lecture to print from argument \"%s\"." % path)
    return
  class_dir = "Class_%02d" % class_number
  if os.path.basename(cwd) == class_dir:
    lecture_home = cwd
  elif os.path.basename(cwd) == "Slides" and os.path.isdir(class_dir):
    lecture_home = os.path.join(cwd, class_dir)
  elif os.path.isdir(os.path.join("Slides", class_dir)):
    lecture_home = os.path.join(cwd, "Slides", class_dir)
  else:
    print("ERROR: Can't find lecture directory", class_dir)
    return
  dest_fname = lecture_template % class_number
  dest_path = os.path.join(lecture_home, dest_fname)
  url = url_template % class_number
  cmd = decktape + args + [url, dest_path]
  print(cmd)
  subprocess.call(cmd)

def main():
    if len(sys.argv) > 1:
      for a in sys.argv[1:]:
        run_decktape(a)

if __name__ == '__main__':
    main()

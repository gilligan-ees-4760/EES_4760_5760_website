import os
import sys
import subprocess
import re
import platform
import getopt

system = platform.system().lower()
if (system == 'windows'):
    decktape = ['decktape.bat',]
elif (system == 'linux'):
    # decktape = 'decktape'
    decktape = ['~/decktape/bin/phantomjs','~/decktape/decktape.js']
    decktape = map(os.path.expanduser, decktape)

# subprocess.call(decktape + ['-h',], shell=True)
resolution = '1920x1080'
#resolution = '1280x1024'

args = ['reveal', '-s', resolution]
incremental_args = ['reveal-incremental', '-s', resolution ]

lecture_template = "EES_4760_5760_Class_%02d_Slides.pdf"
lecture_template_incremental = "EES_4760_5760_Class_%02d_Slides_inc.pdf"
classnum_expr = re.compile('.*_(?P<class_num>[0-9]+)$')


def run_decktape(path, incremental = False):
    if incremental:
        dt_args = incremental_args
        dt_template = lecture_template_incremental
    else:
        dt_args = args
        dt_template = lecture_template
    if os.path.isfile(path):
        path, infile_name = os.path.split(path)
    else:
        infile_name = 'index.html'
    if not os.path.exists(os.path.join(path, infile_name)):
        return
    if infile_name == 'index.html':
        tail = os.path.split(path)[1]
        m = classnum_expr.match(tail)
        if m is None:
            return
        classnum = int(m.group('class_num'))
        outfile_name = dt_template % classnum
    else:
        if incremental:
            outfile_name = infile_name.replace('.html', '_inc.pdf')
        else:
            outfile_name = infile_name.replace('.html', '.pdf')
    home = os.getcwd()
    os.chdir(path)
    print("Changing directory from ", home, " to ", path)
    cmd = decktape + dt_args + [infile_name, outfile_name]
    print(cmd)
    subprocess.call(cmd)
    os.chdir(home)

def runall_decktape(path, incremental = False):
  files = os.listdir(path)
  for f in files:
    ff = os.path.join(path,f)
    if os.path.isdir(ff) and f.lower().startswith('class_'):
      run_decktape(ff)
      runall_decktape(ff)

def main(argv):
    try:
        opts, args = getopt.getopt(argv, "ai", ["all", "incremental"])
    except:
        print("run_decktape.py [-a|--all] [-i|--incremental]")
        sys.exit(2)
    incremental = False
    process_all = False
    for opt, arg in opts:
        if opt in ('-a', '--all'):
            process_all = True
        if opt in ('-i', '--incremental'):
            incremental = True
    if (process_all):
        if (len(args) > 0):
            for d in args:
                if (os.path.isdir(d)):
                    runall_decktape(d, incremental)
        else:
            runall_decktape('Slides', incremental)
    else:
        for d in args:
            if (os.path.isdir(d) and d.lower().startswith('slides') and os.path.exists(os.path.join(d, 'index.html'))):
                run_decktape(d, incremental)
            elif (os.path.isfile(d)):
                run_decktape(d, incremental)
            elif d.isdigit():
                f = os.path.join('Slides', 'Class_%02d' % int(d), 'index.html')
                print("checking ", f)
                if os.path.exists(f):
                    run_decktape(f, incremental)

if __name__ == '__main__':
    main(sys.argv[1:])

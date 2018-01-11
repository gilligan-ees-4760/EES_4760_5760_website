import qrcode
import os, sys

def make_lecture_qr(path = None):
  if (path is None):
      path = os.getcwd()
  node = os.path.split(path)[1]
  qr_text = "https://ees4760.jgilligan.org/Slides/%s/index.html" % node
  qr = qrcode.QRCode(
      version=None,
      error_correction=qrcode.constants.ERROR_CORRECT_H,
      box_size=5
  )
  qr.add_data(qr_text)
  qr.make(fit=True)
  img = qr.make_image()
  return img

def main():
  if len(sys.argv) <= 1:
      dest = ('.',)
  else:
      dest = sys.argv[1:]
  for d in dest:
      img = make_lecture_qr(d)
      img.save(os.path.join(d, 'qrcode.png'), kind="PNG")

if __name__ == "__main__":
    main()

import matplotlib.pyplot as plt
plt.rc("text", usetex=True)
plt.rc("font", family="serif")
plt.rc("font", size=11)

def read_stats(filename):
  t = []
  enst = []
  ke = []

  with open(filename, "r") as data:
    for row in data:
      if not (row[0]=="#"):
        words = row.split()
        t.append(float(words[0]))
        enst.append(float(words[1]))
        ke.append(float(words[3]))

  return t, enst, ke
def plot_stats(x3d_t, x3d_dat, x3d_lab, e3d_t, e3d_dat, e3d_lab,
               xlab, ylab, outfile, figsize=(5.0, 3.5)):

  plt.figure(figsize=figsize)

  plt.plot(x3d_t, x3d_dat, label=x3d_lab)
  plt.plot(e3d_t, e3d_dat, label=e3d_lab)

  plt.xlabel(xlab)
  plt.ylabel(ylab)
  plt.legend(prop={"family":"serif",
                   "size":11})

  plt.savefig(outfile, bbox_inches="tight")
  plt.close()

x3d_t, x3d_enst, x3d_ke = read_stats("./x3d/time_evol.dat")
e3d_t, e3d_enst, e3d_ke = read_stats("./e3d/time_evol.dat")

plot_stats(x3d_t, x3d_enst, "X3D",
           e3d_t, e3d_enst, "Eric",
           r"$t$", r"$\varepsilon$",
           "tgv_enstrophy.eps")
plot_stats(x3d_t, x3d_ke, "X3D",
           e3d_t, e3d_ke, "Eric",
           r"$t$", r"$k$",
           "tgv_ke.eps")

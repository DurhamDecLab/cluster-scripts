# cluster-scripts
Few bits and pieces for working on the HPC cluster, so I don't lose them.

Drain monitor: if you set a node to drain in slurm it can take days, this script goes to background and watches it, checking every 10 minutes, and notifies when it's done. Will time out after several days and terminate.

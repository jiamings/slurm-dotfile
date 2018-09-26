# Make sure you have the following variables.
# $PARTITION=
# $STDOUT_PATH=
# $STDERR_PATH=


# Watch SLURM cluster status
alias sq='squeue -o "%.9u %.9P %80j %.15u %.8T %.10M %.9I %.6D %R"'
alias sqm='sq -u $USER'
alias sqa='sq -p $PARTITION'
alias szsh='srun --partition=$PARTITION --gres=gpu:1 --mem=16000 --time=7-00:00:00 --cpus-per-task=8 --pty zsh'

# Cancel all your jobs except for the zsh shell
function scn() {
  str=$(sqm -h -o '%9i-%50j')
  jobid="$(echo $str | cut -d'-' -f 1 | tr -d '[:space:]')"
  jobname=$(echo $str | cut -d'-' -f 2)
  if [[ $jobname != *"zsh"* ]]; then
    scancel $jobid
  else echo "$jobid is zsh job."
  fi
}

# Read output files based on ID
function vout() {
  vim $STDOUT_PATH/$1.out
}
function verr() {
  vim $STDERR_PATH/$1.out
}

# Read output files based on folder location
alias vo='vout "$(cat jobid)"'
alias ve='verr "$(cat jobid)"'

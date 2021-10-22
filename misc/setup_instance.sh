# run with source setup_instance.sh (so it runs in the shell that is starting the script and does not create a new shell)

# install useful programs
sudo apt update
sudo apt-get install htop zip rsync tmux git nginx -y

# install things needed to run aws cli (apparently needed due to a bug)
sudo apt-get install -y -qq groff
sudo apt-get install -y -qq less

# configure git
git config --global core.autocrlf false
git config --global core.eol lf

# configure tmux
wget http://paulguerrero.net/misc/tmux_config.txt
mv tmux_config.txt ~/.tmux.conf

# configure nginx
wget http://paulguerrero.net/misc/nginx.conf
sudo mv nginx.conf /etc/nginx/nginx.conf
sudo service nginx start

# install miniconda and some packages
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod u+x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda

printf "\nexport PATH=\$HOME/miniconda/bin:\$PATH\n" >> ~/.bashrc
printf "source \$HOME/miniconda/bin/activate\n" >> ~/.bashrc
export PATH=$HOME/miniconda/bin:$PATH
source $HOME/miniconda/bin/activate

# raise the max open file limit (seems to be necessary sometimes because conda alone seems to open nearly 1024 (original limit) library files)
printf "\nulimit -n 16384\n" >> ~/.bashrc
ulimit -n 16384

conda install ipython numpy psutil -y
conda install -c conda-forge jupyterlab nodejs -y

# create symlinks to user and scratch space in the home directory for easier access
ln -s $(readlink -f /home/code-base/user_space) ~/user_space
ln -s $(readlink -f /home/code-base/scratch_space) ~/scratch_space

git config --global user.email "guerrero@adobe.com"
git config --global user.name "Paul Guerrero"

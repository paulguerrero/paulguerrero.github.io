# run with source setup_instance.sh (so it runs in the shell that is starting the script and does not create a new shell)
printf "\nexport PYTHONPATH=\$CODE_BASE/app:\$CODE_BASE/app/python:\$CODE_BASE/app/python/sensei_sdk:\$CODE_BASE/app/python/dev:\$LIBS_BASE/python/miniconda:\$LIBS_BASE/python/sensei_sdk:\$LIBS_BASE/python/senseinbs:$LIBS_BASE/plugins:\$LIBS_BASE/plugins/jupyterlab-zip\n" >> ~/.bashrc
export PYTHONPATH=$CODE_BASE/app:$CODE_BASE/app/python:$CODE_BASE/app/python/sensei_sdk:$CODE_BASE/app/python/dev:$HOME/miniconda:$LIBS_BASE/python/sensei_sdk:$LIBS_BASE/python/senseinbs:$LIBS_BASE/plugins:$LIBS_BASE/plugins/jupyterlab-zip

printf "\nexport PATH=\$PATH:/usr/local/nvidia/bin:/usr/local/cuda/bin\n" >> ~/.bashrc
export PATH=$PATH:/usr/local/nvidia/bin:/usr/local/cuda/bin

printf "\nexport CPATH=\$CPATH:/usr/local/cuda/include\n" >> ~/.bashrc
export CPATH=$CPATH:/usr/local/cuda/include

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

conda install ipython numpy -y
conda install pytorch torchvision cudatoolkit=10.2 -c pytorch -y
pip install tensorboard
conda install scipy scikit-learn matplotlib psutil -y
conda install -c conda-forge trimesh progressbar2 jupyterlab nodejs -y
pip install torch-scatter==latest+cu102 -f https://pytorch-geometric.com/whl/torch-1.6.0.html
conda install pandas -y

# filebrwoser
#curl -fsSL https://filebrowser.xyz/get.sh | bash

# for plotly and plotly-orca (to save as svg)
# conda install -c plotly plotly=4.2.1 plotly-orca psutil requests -y
conda install -c plotly plotly plotly-orca psutil requests -y
sudo apt install xvfb libgtk2.0-0 libgconf-2-4 -y
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install google-chrome-stable -y

# create symlinks to user and scratch space in the home directory for easier access
ln -s $(readlink -f /home/code-base/user_space) ~/user_space
ln -s $(readlink -f /home/code-base/scratch_space) ~/scratch_space

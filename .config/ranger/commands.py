# https://superuser.com/questions/1048647/how-to-define-new-commands-in-the-ranger-file-manager/1048648


from ranger.api.commands import Command
from ranger.api.commands import *

class newcmd(Command):
    def execute(self):
        if not self.arg(1):
            self.fm.notify('Wrong number of arguments', bad=True)
            return
        # First argument. 0 is the command name.
        self.fm.notify(self.arg(1))
        # Current directory to status line.
        self.fm.notify(self.fm.thisdir)
        # Run a shell command.
        self.fm.run(['touch', 'newfile'])
        
# Visit frequently used directories
# https://github.com/ranger/ranger/wiki/Commands        
# This command uses fasd to jump to a frequently visited directory with a given substring of its path.

class fasd(Command):
    """
    :fasd

    Jump to directory using fasd
    """
    def execute(self):
        import subprocess
        arg = self.rest(1)
        if arg:
            directory = subprocess.check_output(["fasd", "-d"]+arg.split(), universal_newlines=True).strip()
            self.fm.cd(directory)    

## fzf integration

class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else: 
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)            
                
                
#  https://github.com/ranger/ranger/issues/255        
from subprocess import PIPE
class fzfcd(Command):
    def execute(self):
        command="find -L \( -path '*.wine-pipelight' -o -path '*.ivy2*' -o -path '*.texlive*' -o -path '*.git' -o -path '*.metadata' -o -path '*_notes' \) -prune -o -type d -print 2>/dev/null | fzf"
        fzf = self.fm.execute_command(command, stdout=PIPE)
        stdout, stderr = fzf.communicate()
        directory = stdout.decode('utf-8').rstrip('\n')
        self.fm.cd(directory)            
 
 
class fzfsearch(Command):
    def execute(self):
        command="fd.sh txt"
        fzf = self.fm.execute_command(command, stdout=PIPE)
        stdout, stderr = fzf.communicate()
        directory = stdout.decode('utf-8').rstrip('\n')
        #self.fm.cd(directory)                
        
# ~/.config/ranger/commands.py
from ranger.api.commands import *
import ranger.fsobject.directory        
original_accept_file = ranger.fsobject.directory.accept_file

# this was copy&pasted from ranger/fsobject/directory.py and modified
# to make filters case insensitive
def insensitive_accept_file(fname, dirname, hidden_filter, name_filter):
    if hidden_filter:
        try:
            if hidden_filter.search(fname):
                return False
        except:
            if hidden_filter in fname:
                return False
    if name_filter and name_filter.lower() not in fname.lower():
        return False
    return True

class filter(Command):
    def quick(self):
        ranger.fsobject.directory.accept_file = original_accept_file
        self.fm.set_filter(self.rest(1))
        self.fm.reload_cwd()

class filter_i(Command):
    def quick(self):
        ranger.fsobject.directory.accept_file = insensitive_accept_file
        self.fm.set_filter(self.rest(1))
        self.fm.reload_cwd()        

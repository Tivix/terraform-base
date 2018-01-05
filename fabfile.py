from fabric.api import local, env
from fabric.colors import cyan, green, red

def prod():
    env.ENV = 'prod'

def staging():
    env.ENV = 'staging'

def infra():
    # this one will build whole aws infra
    print(green("\nTerraform bootstraping - setting whole infra on AWS ...\n"))
    local('cd %s && terraform init && terraform apply -var-file="../vars_secrets.tfvars"' % env.ENV)

def up():
    infra()

def destroy():
    # destroys whole infra
    print(red("\n\nTerraform - destroying whole infra!!!\n"))
    if confirm(prompt='This will destroy whole env - are you sure?', resp=False):
        local('cd %s && terraform init && terraform destroy -var-file="../vars_secrets.tfvars"' % env.ENV)

def compare():
    # compares files for prod and staging - shouldn't be significant differences except variables
    local('diff -ENwbur -x "*.tfstate*" -x ".terraform" prod/ staging/')

# global functions
def confirm(prompt=None, resp=False):    
    if prompt is None:
        prompt = 'Confirm'

    if resp:
        prompt = '%s [%s]|%s: ' % (prompt, 'y', 'n')
    else:
        prompt = '%s [%s]|%s: ' % (prompt, 'n', 'y')
        
    while True:
        ans = raw_input(prompt)
        if not ans:
            return resp
        if ans not in ['y', 'Y', 'n', 'N']:
            print 'please enter y or n.'
            continue
        if ans == 'y' or ans == 'Y':
            return True
        if ans == 'n' or ans == 'N':
            return False
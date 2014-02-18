# Converts old versions of USM to new USM
import os

ROOT = os.path.join(os.path.expanduser("~"), "Apps")

def choose_version(software, exclude=()):
    "Asks the user to pick a particular version, for whatver reason"
    versions = os.listdir(os.path.join(ROOT, software))
    for exclusion in exclude:
        versions.remove(exclusion)

    acceptable_inputs = []
    for idx, version in enumerate(versions):
        acceptable_inputs.append(str(idx))
        print("[{}]".format(idx), version)

    if not acceptable_inputs:
        return None

    choice = ''
    while choice not in acceptable_inputs:
        choice = input('>')
    return versions[int(choice)]

def make_link(software, version, remove=True):
    "Sets the default version of a software"
    try:
        os.remove(os.path.join(ROOT, software, 'current'))
    except FileNotFoundError:
        pass
    os.symlink(os.path.join(ROOT, software, version), os.path.join(ROOT, software, 'current'))

softwares = {}
for software_vsn in os.listdir(ROOT):
    if os.path.basename(software_vsn) != 'install':
        try:
            _ = os.path.basename(software_vsn).split('--')
            print(":: Found software", _)
            software, version = os.path.basename(software_vsn).split('--')

            # Avoid clashing with the symlink
            if version == 'current':
                new_version = 'dev'
            else:
                new_version = version

            if not os.path.exists(os.path.join(ROOT, software)):
                print(":: Creating fresh path for", software)
                os.mkdir(os.path.join(ROOT, software))
                softwares[software] = []

            softwares[software].append(new_version)
            print(":: Adding", software, "version", new_version)
            os.rename(os.path.join(ROOT, software + '--' + version), os.path.join(ROOT, software, new_version))
        except ValueError:
            pass

for software, versions in softwares.items():
    if len(versions) > 1:
        print("Choose the version to use with", software)
        version = choose_version(software)
    else:
        version = versions[0]

    print(":: Making", version, "the default")
    make_link(software, version)

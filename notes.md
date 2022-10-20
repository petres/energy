Updating existing env with env yml file:

    conda env update --file conda-env.yml --prune

Export env without prefix:

    conda env export | grep -v "^prefix: " > conda-env.yml

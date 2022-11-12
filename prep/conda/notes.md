Updating existing env with env yml file:

    conda env update --file env.yml --prune

Export env without prefix:

    conda env export | grep -v "^prefix: " > env.yml

# Getting Started 

## create 1-job
add job - build - execute shell
```bash
echo hello world
```

## 1-job step-2
```bash
docker exec -ti jenkins bash
echo "Current date is $(date)"
```

## Redirect job output
```bash
NAME=Teguh
echo "Hi,$NAME Current date is $(date)" > /tmp/echo
```

## Bash script
create script.sh
```bash
#!/bin/bash

NAME=$1
LASTNAME=$2
echo "hello, $NAME $LASTNAME"
```
Execute:
```bash
chmod +x .script.sh
./script.sh
```

## Execute bash script from jenkins
copy jenkins to container
```bash
docker cp script.sh jenkins:/tmp/script1.sh
```

build environment > build > execute shell
```bash
NAME=Teguh
LASTNAME=fihaiman
./script1.sh $NAME $LASTNAME
```

## Parameter jenkins
check this project parameterized > add parameter > string parameter 
```bash
./script1.sh $NAME $LASTNAME
```

## Explore with list parameter 
do explore with list parameter

## Explore with boolean parameter
```bash
#!/bin/bash

NAME=$1
LASTNAME=$2
SHOW=$3

if [ "$SHOW" = "true" ]; then
  echo "Hello, $NAME $LASTNAME"
else
  echo "please mark yes"
fi
```
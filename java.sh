#!/bin/sh

if [ -z "$JAVA_OPTS" ]; then
  JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom"
fi

java $JAVA_OPTS $*

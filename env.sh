if ! docker start -i `docker ps -qaf ancestor=cs354/student-env`; then
  docker run -it --network host cs354/student-env
fi

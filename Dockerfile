FROM ghcr.io/graalvm/graalvm-ce:21.1.0
MAINTAINER "Ge Qilong"
RUN gu install native-image
RUN curl -o apache-maven-3.6.3-bin.tar.gz http://apache-mirror.rbc.ru/pub/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
RUN tar xzvf apache-maven-3.6.3-bin.tar.gz
RUN cp -R apache-maven-3.6.3 /usr/local/bin
RUN mkdir -p /usr/local/maven_repo
ADD conf/settings.xml /usr/local/bin/apache-maven-3.6.3/conf
RUN export PATH=apache-maven-3.6.3/bin:$PATH
RUN export PATH=/usr/local/bin/apache-maven-3.6.3/bin:$PATH
RUN ln -s /usr/local/bin/apache-maven-3.6.3/bin/mvn /usr/local/bin/mvn

VOLUME /project
VOLUME /app
ADD src /project
ADD pom.xml /project
WORKDIR /project
RUN mvn -Pnative -DskipTests package

RUN cp /project/target/hellodockerwolrd.exe /app/hellodockerwolrd.exe
EXPOSE 8080
ENTRYPOINT ["/app/hellodockerworld.exe"]
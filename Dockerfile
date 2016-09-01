FROM debian:jessie
MAINTAINER Michael Grenier "michael.grenier@live.com"

RUN groupadd -g 503 ut-server &&\
		useradd -u 503 -g 503 -d /opt/ut-server ut-server

RUN apt-get update &&\
		apt-get install -y bzip2 w3m wget lib32z1 lib32ncurses5 &&\
		rm -rf /var/lib/apt/lists/* &&\
		wget http://ut-files.com/Entire_Server_Download/ut-server-436.tar.gz -O /tmp/ut-server.tar.gz &&\
		tar -zxf /tmp/ut-server.tar.gz -C /opt &&\
		rm -f /tmp/ut-server.tar.gz &&\
		cd /opt/ut-server &&\
		wget http://www.ut-files.com/Patches/UTPGPatch451LINUX.tar.tar -O /tmp/UTPGPatch451LINUX.tar.tar &&\
		tar xfj /tmp/UTPGPatch451LINUX.tar.tar -C /opt/ut-server &&\
		rm -f /tmp/UTPGPatch451LINUX.tar.tar &&\
		cd System &&\
		cp libSDL-1.1.so.0 libSDL-1.2.so.0 &&\
		apt-get purge -y bzip2 w3m &&\
		apt-get autoremove -y &&\
		chown -R ut-server:ut-server /opt/ut-server

COPY ./UnrealTournament.ini /opt/ut-server/System/UnrealTournament.ini

USER ut-server
WORKDIR /opt/ut-server/System

EXPOSE 5080 27900/udp 7777-7781/udp
ENTRYPOINT ["/opt/ut-server/System/ucc-bin"]
CMD ["server", "DM-Barricade?game=Botpack.DeathMatchPlus", "userini=User.ini", "ini=/opt/ut-server/System/UnrealTournament.ini", "--nohomedir"]

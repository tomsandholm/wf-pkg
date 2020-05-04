NAME=wildfly
TARGET=/opt

targets:
	echo 'the following targets are available...'
	@grep '^[^#[:space:]].*:' Makefile | grep -v targets

all:
	make clean
	make 16.0.0-jdk8
	make 16.0.0-jdk11
	make 17.0.0-jdk11
	make 18.0.1-jdk11
	make 19.0.0-jdk11

16.0.0-jdk8:
	$(call setup, http://download.jboss.org/wildfly/16.0.0.Final/wildfly-16.0.0.Final.tar.gz,wildfly-16.0.0.Final,16.0.0-jdk8,openjdk-8-jdk)
16.0.0-jdk11:
	$(call setup, http://download.jboss.org/wildfly/16.0.0.Final/wildfly-16.0.0.Final.tar.gz,wildfly-16.0.0.Final,16.0.0-jdk11,openjdk-11-jdk)
17.0.0-jdk11:
	$(call setup, http://download.jboss.org/wildfly/17.0.0.Final/wildfly-17.0.0.Final.tar.gz,wildfly-17.0.0.Final,17.0.0-jdk11,openjdk-11-jdk)
18.0.1-jdk11:
	$(call setup, http://download.jboss.org/wildfly/18.0.1.Final/wildfly-18.0.1.Final.tar.gz,wildfly-18.0.1.Final,18.0.1-jdk11,openjdk-11-jdk)
19.0.0-jdk11:
	$(call setup, https://download.jboss.org/wildfly/19.0.0.Final/wildfly-19.0.0.Final.tar.gz,wildfly-19.0.0.Final,19.0.0-jdk11,openjdk-11-jdk)
clean:
	rm -rf *.deb
	rm -rf *.gz*
	rm -rf wildfly_*
	rm -rf wildfly*Final


define setup
	wget -q $(1)
	tar xfz `basename $(1)`
	mkdir -p $(2)/systemd
	mkdir -p $(2)/etc/wildfly
	mkdir -p $(2)/properties
	cp $(2)/docs/contrib/scripts/systemd/wildfly.service $(2)/systemd/
	cp $(2)/docs/contrib/scripts/systemd/wildfly.conf $(2)/etc/wildfly
	cp $(2)/docs/contrib/scripts/systemd/launch.sh $(2)/bin/
	cp $(2)/mgmt-groups.properties $(2)/standalone/configuration/
	cp $(2)/mgmt-users.properties $(2)/standalone/configuration/
	fpm -v $(3) --deb-no-default-config-files --description "$(2)" -d $(4) -s dir -t deb -n $(NAME) --prefix $(TARGET) --after-install post-install --after-remove post-uninstall $(2)
endef


FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

PACKAGECONFIG:append = " json"

SRC_URI:append = " \
                  file://events.json \
                  file://fans.json \
                  file://groups_1p.json \
                  file://groups_2p.json \
                  file://zones.json \
                  file://monitor.json \
                  file://presence.json \
                  file://phosphor-fan-control@.service \
                  file://phosphor-fan-monitor@.service \
                  file://phosphor-fan-presence-tach@.service \
                 "

MITCHELL_COMPAT_NAME = "com.ampere.Hardware.Chassis.Model.MtMitchell"

CONTROL_CONFIGS = "events.json fans.json zones.json groups_2p.json groups_1p.json"

do_install:append () {
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${UNPACKDIR}/phosphor-fan-monitor@.service ${D}${systemd_system_unitdir}
        install -m 0644 ${UNPACKDIR}/phosphor-fan-control@.service ${D}${systemd_system_unitdir}
        install -m 0644 ${UNPACKDIR}/phosphor-fan-presence-tach@.service ${D}${systemd_system_unitdir}

        # datadir = /usr/share
        install -d ${D}${datadir}/phosphor-fan-presence/control/${MITCHELL_COMPAT_NAME}
        install -d ${D}${datadir}/phosphor-fan-presence/monitor/${MITCHELL_COMPAT_NAME}
        install -d ${D}${datadir}/phosphor-fan-presence/presence/${MITCHELL_COMPAT_NAME}

        for CONTROL_CONFIG in ${CONTROL_CONFIGS}
        do
                install -m 0644 ${UNPACKDIR}/${CONTROL_CONFIG} \
                        ${D}${datadir}/phosphor-fan-presence/control/${MITCHELL_COMPAT_NAME}
        done

        install -m 0644 ${UNPACKDIR}/groups_2p.json \
               ${D}${datadir}/phosphor-fan-presence/control/${MITCHELL_COMPAT_NAME}/groups.json

        install -m 0644 ${UNPACKDIR}/monitor.json \
                ${D}${datadir}/phosphor-fan-presence/monitor/${MITCHELL_COMPAT_NAME}/config.json
        install -m 0644 ${UNPACKDIR}/presence.json \
                ${D}${datadir}/phosphor-fan-presence/presence/${MITCHELL_COMPAT_NAME}/config.json
}

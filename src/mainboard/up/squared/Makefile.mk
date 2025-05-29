## SPDX-License-Identifier: GPL-2.0-only

bootblock-y += bootblock.c

romstage-y += romstage.c

ramstage-y += ramstage.c
ramstage-y += red_unlock.c
ramstage-y += lib-micro-x86/lib-micro-minimal.c

ramstage-$(CONFIG_MAINBOARD_USE_LIBGFXINIT) += gma-mainboard.ads

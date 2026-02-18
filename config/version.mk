PRODUCT_VERSION_MAJOR = 23
PRODUCT_VERSION_MINOR = 2

ifeq ($(LINEAGE_VERSION_APPEND_TIME_OF_DAY),true)
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    LINEAGE_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Default to UNOFFICIAL
LINEAGE_BUILDTYPE := UNOFFICIAL

# Check all possible overlay locations for official build flag
OVERLAY_PATHS := \
    device/*/$(LINEAGE_BUILD)/overlay/packages/apps/Settings/res/values/strings.xml \
    device/*/$(LINEAGE_BUILD)/rro_overlays/SettingsOverlayDevice/res/values/strings.xml \
    device/*/$(LINEAGE_BUILD)/rro_overlays/SettingsProviderOverlay/res/values/strings.xml

DEVICE_OVERLAYS := $(wildcard $(OVERLAY_PATHS))

ifneq ($(DEVICE_OVERLAYS),)
    DT_OFFICIAL := $(shell grep -h 'soulaosp_official_build">true<' $(DEVICE_OVERLAYS) 2>/dev/null)
    ifneq ($(DT_OFFICIAL),)
        SOULAOSP_DEVICES_XML := vendor/soulOTA/devices.xml
        ifneq ($(wildcard $(SOULAOSP_DEVICES_XML)),)
            IS_OFFICIAL := $(shell grep '<device>$(LINEAGE_BUILD)</device>' $(SOULAOSP_DEVICES_XML) 2>/dev/null)
            ifneq ($(IS_OFFICIAL),)
                LINEAGE_BUILDTYPE := OFFICIAL
            endif
        endif
    endif
endif

# Set version suffix
LINEAGE_VERSION_SUFFIX := $(LINEAGE_BUILD_DATE)-$(LINEAGE_BUILDTYPE)-$(LINEAGE_BUILD)

# Internal version
LINEAGE_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(LINEAGE_VERSION_SUFFIX)

# Display version
LINEAGE_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(LINEAGE_VERSION_SUFFIX)

# LineageOS version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lineage.version=$(LINEAGE_VERSION) \
    ro.lineage.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.lineage.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.lineage.releasetype=$(LINEAGE_BUILDTYPE)

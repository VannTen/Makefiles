#* ************************************************************************** *#
#*                                                                            *#
#*                                                        :::      ::::::::   *#
#*   Rules.mk                                           :+:      :+:    :+:   *#
#*                                                    +:+ +:+         +:+     *#
#*   By: mgautier <mgautier@student.42.fr>          +#+  +:+       +#+        *#
#*                                                +#+#+#+#+#+   +#+           *#
#*   Created: 2016/12/13 19:41:31 by mgautier          #+#    #+#             *#
#*   Updated: 2016/12/18 00:23:55 by                  ###   ########.fr       *#
#*                                                                            *#
#* ************************************************************************** *#

#
# set DIR to current directory, using SUBDIR, passed by the upper level Rules.mk
# If that one is the top level, DIR is set to himself
#
STACK_POINTER := $(STACK_POINTER).x
DIR_$(STACK_POINTER) := $(DIR)
DIR := $(DIR)$(SUBDIR)

# Inclusion of subdirs Rules.mk

SUBDIRS := foo/ bar/

$(info current dir : $(DIR) entering subdirs)
$(foreach SUBDIR,$(SUBDIRS),$(eval $(INCLUDE_SUBDIRS)))

$(info current dir : $(DIR) leaving subdirs)
# Local sources files and target

-include $(DIR)Srcs.mk

# Standard expansion of the SRC into the local OBJ and DEP
# + add them to clean-up variables

$(info before var assign$(DIR) et $(TARGET))
OBJ_$(DIR) := $(OBJ)
DEP_$(DIR) := $(DEP)
ifdef TARGET
TARGET_$(DIR) := $(DIR)$(TARGET)
endif
CLEAN += $(OBJ_$(DIR))
FCLEAN += $(TARGET_$(DIR)) $(DEP_$(DIR))

$(info fclean : $(FCLEAN))
-include $(DEP_$(DIR))

#
#Local rules
#

$(TARGET_$(DIR)): $(OBJ_$(DIR))
	$(LINK_STATIC_LIB)

$(OBJ_$(DIR)): CFLAGS_TGT := -iquote$(DIR)$(HEADER_DIR)

$(TARGET_$(DIR)): LDFLAGS_TGT := -L.$(DIR)$(LIB_DIR) -l$(LIB_NAME)


#
# Tracking current directory

DIR := $(DIR_$(STACK_POINTER))
STACK_POINTER := $(basename $(STACK_POINTER))

#* ************************************************************************** *#
#*                                                                            *#
#*                                                        :::      ::::::::   *#
#*   Rules.mk                                           :+:      :+:    :+:   *#
#*                                                    +:+ +:+         +:+     *#
#*   By: mgautier <mgautier@student.42.fr>          +#+  +:+       +#+        *#
#*                                                +#+#+#+#+#+   +#+           *#
#*   Created: 2016/12/13 19:41:31 by mgautier          #+#    #+#             *#
#*   Updated: 2016/12/16 17:12:53 by mgautier         ###   ########.fr       *#
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

SRC := 

# Standard expansion of the SRC into the local OBJ and DEP
# + add them to clean-up variables

OBJ_$(DIR) := $(OBJ)
DEP_$(DIR) := $(DEP)
TARGET_$(DIR) := $(DIR)$(TARGET)
CLEAN += $(OBJ_$(DIR))
FCLEAN += $(TARGET_$(DIR)) $(DEP_$(DIR))


-include $(DEP_$(DIR))

#
#Local rules
#

$(TARGET): $(OBJ_$(DIR))
	$(LINK_STATIC_LIB)

OBJ_$(DIR): CFLAGS_TGT := -iquote$(DIR)$(HEADER_DIR)


#
# Tracking current directory
#

DIR := $(DIR_$(STACK_POINTER))
STACK_POINTER := $(basename $(STACK_POINTER))

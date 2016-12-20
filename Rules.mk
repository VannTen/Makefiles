#* ************************************************************************** *#
#*                                                                            *#
#*                                                        :::      ::::::::   *#
#*   Rules.mk                                           :+:      :+:    :+:   *#
#*                                                    +:+ +:+         +:+     *#
#*   By: mgautier <mgautier@student.42.fr>          +#+  +:+       +#+        *#
#*                                                +#+#+#+#+#+   +#+           *#
#*   Created: 2016/12/13 19:41:31 by mgautier          #+#    #+#             *#
#*   Updated: 2016/12/20 14:38:35 by mgautier         ###   ########.fr       *#
#*                                                                            *#
#* ************************************************************************** *#

#
# set DIR to current directory, using SUBDIR, passed by the upper level Rules.mk
# If that one is the top level, DIR is set to himself
#
STACK_POINTER := $(STACK_POINTER).x
DIR_$(STACK_POINTER) := $(DIR)
DIR := $(DIR)$(SUBDIR)

# Local sources files and target

include $(DIR)Srcs.mk

# Standard expansion of the SRC into the local OBJ and DEP
# + add them to clean-up variables
# + check if the target of this directory is indicated

OBJ_$(DIR) := $(OBJ)
DEP_$(DIR) := $(DEP)
PREREQUISITES := $(OBJ_$(DIR)) $(ELSE) $(LIBRARY)
ifdef TARGET
TARGET_$(DIR) := $(DIR)$(TARGET)
else
$(eval $(TARGET_ERROR))
endif
# If the target is a static library, use the approriate recipe.
# Otherwise, use the linker for an executable

ifeq ($(suffix $(TARGET)),.a)
$(TARGET_$(DIR)): RECIPE = $(LINK_STATIC_LIB)
else
$(TARGET_$(DIR)): RECIPE = $(LINK_EXE)
endif

# Clean variables 
# If this is the top level (the one where make is invoked) do add the Makefile
# and the Rules.mk files to MKCLEAN

CLEAN += $(OBJ_$(DIR))
FCLEAN += $(TARGET_$(DIR)) $(DEP_$(DIR))
ifneq ($(DIR),)
MKCLEAN += $(DIR)Makefile $(DIR)Rules.mk
endif

-include $(DEP_$(DIR))

# Local rules

$(info desdes $(TARGET_$(DIR)) $(PREREQUISITES))
$(TARGET_$(DIR)): $(PREREQUISITES)
	$(RECIPE)

# If the target is different from the one make is invoked in,
# add it to the search path for headers.
# If the target requiert a library, add its directory too.

ifdef DIR
$(TARGET_$(DIR)): CPPFLAGS := $(CPPFLAGS) -iquote$(DIR)
endif
ifdef LIBRARY
$(TARGET_$(DIR)): CPPFLAGS := $(CPPFLAGS) -iquote$(dir $(LIBRARY))
endif

# Inclusion of subdirs Rules.mk

$(foreach SUBDIR,$(SUBDIRS),$(eval $(INCLUDE_SUBDIRS)))

# Tracking current directory

DIR := $(DIR_$(STACK_POINTER))
STACK_POINTER := $(basename $(STACK_POINTER))

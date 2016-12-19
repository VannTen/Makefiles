#* ************************************************************************** *#
#*                                                                            *#
#*                                                        :::      ::::::::   *#
#*   Makefile                                           :+:      :+:    :+:   *#
#*                                                    +:+ +:+         +:+     *#
#*   By: mgautier <mgautier@student.42.fr>          +#+  +:+       +#+        *#
#*                                                +#+#+#+#+#+   +#+           *#
#*   Created: 2016/11/04 13:12:11 by mgautier          #+#    #+#             *#
#*   Updated: 2016/12/19 18:04:19 by mgautier         ###   ########.fr       *#
#*                                                                            *#
#* ************************************************************************** *#

.DEFAULT_GOAL:= all

# Build tools

SYSTEM = $(shell uname)
AR = ar 
ARFLAGS = rc
ifeq ($(SYSTEM),Linux)
	ARFLAGS += -U
endif

CC = gcc
CFLAGS = -Wall -Wextra -Werror -ansi -pedantic-errors
CFLAGS += $(CFLAGS_TGT)
CPPFLAGS :=

DEPFLAGS = -MT $@ -MP -MMD -MF $(word 2,$^).tmp

COMPILE = $(CC) $(DEPFLAGS) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
POSTCOMPILE = sed -E "s/[a-z_.:]+/\$$(DIR)&/g" $(word 2,$^).tmp > $(word 2,$^)

# DIRECTORY TARGETS RECIPES

# Static libary maintainer
LINK_STATIC_LIB = $(AR) $(ARFLAGS) $@ $?

# Executable linker
LINK_EXE = $(CC) $(LDFLAGS) $^ -o $@ $(LDFLAGS_TGT)

# These variables are used to obtain the .o and .dep files list
# for each level of the projet, by using the current value of SRC.

OBJ = $(patsubst %.c,$(DIR).%.o,$(SRC))
DEP = $(patsubst %.c,$(DIR).%.dep,$(SRC))

# Clean-up variables
# Collect all the files that need to be deleted along all the project tree
# the clean-up rules then use them to do their job

CLEAN :=
FCLEAN :=
MKCLEAN :=

# Compilation rule
# Generate dependencies as a side effet

%.o: %.c
.%.o: %.c .%.dep
	$(COMPILE)
	$(POSTCOMPILE)
	$(RM) $(word 2,$^).tmp

%.dep: ;

.PRECIOUS: %.dep

# Rules to generate the needed Makefiles in the subdirectories

%/Rules.mk: | %/Makefile
	ln Rules.mk $@
%/Makefile:
	ln Makefile $(dir $@)Makefile
.PRECIOUS: %/Makefile
# Functions

define INCLUDE_SUBDIRS
include $(DIR)$(SUBDIR)Rules.mk
endef

define TARGET_ERROR
$$(error $$(DIR) : No target if indicated for that directory))
endef

DIR = 
include Rules.mk

# Mandatory rules
# These are the rules which will be specified by the user as arguments to make

all: $(TARGET_$(DIR))

clean:
	$(RM) $(CLEAN)
	
mkclean:
	$(RM) $(MKCLEAN)

fclean: clean mkclean
	$(RM) $(FCLEAN)

re: fclean all

.PHONY: debug all clean fclean mkclean re

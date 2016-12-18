#* ************************************************************************** *#
#*                                                                            *#
#*                                                        :::      ::::::::   *#
#*   Makefile                                           :+:      :+:    :+:   *#
#*                                                    +:+ +:+         +:+     *#
#*   By: mgautier <mgautier@student.42.fr>          +#+  +:+       +#+        *#
#*                                                +#+#+#+#+#+   +#+           *#
#*   Created: 2016/11/04 13:12:11 by mgautier          #+#    #+#             *#
#*   Updated: 2016/12/17 21:59:05 by                  ###   ########.fr       *#
#*                                                                            *#
#* ************************************************************************** *#


# General variables (compiling and such). Will be kept in the local Makefile

.DEFAULT_GOAL:= all
# Static libary maintainer
AR = ar 
ARFLAGS = rc
LINK_STATIC_LIB = $(AR) $(ARFLAGS) $@ $?

CC = gcc
CFLAGS = -Wall -Wextra -Werror -ansi -pedantic-errors
CFLAGS += $(CFLAGS_TGT)

DEPFLAGS = -MT $@ -MP -MMD -MF $(word 2,$^).tmp

COMPILE = $(CC) $(DEPFLAGS) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
POSTCOMPILE = sed -E "s/[a-z_.:]+/\$$(DIR)&/g" $(word 2,$^).tmp > $(word 2,$^)
$(info $(POSTCOMPILE))
DIR = 

# These variables are used to obtain the .o and .dep files list
# for each level of the projet, by using the current value of SRC.

OBJ = $(patsubst %.c,$(DIR).%.o,$(SRC))
DEP = $(patsubst %.c,$(DIR).%.dep,$(SRC))

# Clean-up variables
# Collect all the files that need to be deleted along all the project tree
# the clean-up rules then use them to do their job

CLEAN :=
FCLEAN :=

# Compilation rule
# Generate dependencies as a side effet

%.o: %.c
.%.o: %.c .%.dep
	$(COMPILE)
	$(POSTCOMPILE)
	touch $@

%.dep: ;

.PRECIOUS: %.dep

# Functions

define INCLUDE_SUBDIRS
include $(DIR)$(SUBDIR)Rules.mk
endef

include Rules.mk

# Mandatory rules

all: $(TARGET)

clean:
	$(RM) $(CLEAN)

fclean: clean
	$(RM) $(FCLEAN)

re: fclean all

.PHONY: debug all clean fclean re

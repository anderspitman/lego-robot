NAME := concept_map

$(NAME): $(NAME).dot
	dot -Tpng $(NAME).dot -o $(NAME).png

.PHONY: clean
clean:
	rm $(NAME).png


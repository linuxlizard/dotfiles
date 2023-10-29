/* davep 20220905 ; I'm bored. Let's write a brainfuck interpretter. */
/* gcc -g -Wall -Wpedantic -Wextra -Wconversion -o bf bf.c */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#define PTR_FREE(p) do { free(p); p=NULL; } while(0);

unsigned char memory[30000];
unsigned char *p = memory;

// hello world from wikipedia
char hello_world[] = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.";

// read a char, write a char, infinite loop
char loop[] = ",.[,.]";

// program counter
char *PC;

// stack and stack register
char * stack[1024];
char **SR = stack;

int load_file(const char *filename, char **out_buf)
{
	struct stat stats;
	char *buf = NULL;

	int err = stat(filename, &stats);
	if (err<0) {
		// preserve errno
		err = errno;
		fprintf(stderr, "stat file \"%s\" failed err=%d %s\n", filename, errno, strerror(errno));
		return -err;
	}

	int fd = open(filename, O_RDONLY);
	if (fd<0) {
		err = errno;
		fprintf(stderr, "open file \"%s\" failed err=%d %s\n", filename, errno, strerror(errno));
		return -err;
	}

	size_t data_size = (size_t)stats.st_size;
	buf = malloc(data_size);
	if (!buf) {
		err = -ENOMEM;
		goto fail;
	}

	// read rest of file
	ssize_t count = read(fd, buf, data_size);
	if (count < 0) {
		err = errno;
		fprintf(stderr, "read file \"%s\" failed err=%d %s\n", filename, errno, strerror(errno));
		goto fail;
	}

	if (count != stats.st_size) {
		err = EINVAL;
		goto fail;
	}

	*out_buf = buf;
	close(fd);
	return 0;

fail:
	close(fd);
	if (buf) {
		PTR_FREE(buf);
	}
	return -err;
}


int main(int argc, char* argv[])
{
	int counter=0;
	char *buf;

	PC = hello_world;
	if (argc>1) {
		load_file(argv[1], &buf);
		PC = buf;
	}

	while(*PC) {
		switch (*PC++) {
			case '>': ++p; break;

			case '<': --p; break;

			case '+': ++*p; break;

			case '-': --*p; break;

			case '.': putchar(*p); break;

			case ',': *p = (unsigned char)getchar(); break;

			// while(*p) {
			case '[': 
				if (*p) {
					*SR++ = PC-1;
				}
				else {
					// seek matching ']'
					counter++;
					while (*PC++) {
						if (*PC=='[') {
							counter++;
						}
						else if (*PC==']') {
							counter--;
							if (counter==0) {
								// found matching ']'
								// go past ']'
								PC++;
								break;
							}
						}
					}
				}
				break;

			// }
			case ']':
				PC = *--SR;
				break;
		}

	}

	return 0;
}


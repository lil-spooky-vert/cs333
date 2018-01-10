
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// remove this stub once you implement the date() system call.
#include "types.h"
#include "user.h"
int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  printf(1, "Not imlpemented yet.\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 87 08 00 00       	push   $0x887
  19:	6a 01                	push   $0x1
  1b:	e8 b1 04 00 00       	call   4d1 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  exit();
  23:	e8 2a 03 00 00       	call   352 <exit>

00000028 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	57                   	push   %edi
  2c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  30:	8b 55 10             	mov    0x10(%ebp),%edx
  33:	8b 45 0c             	mov    0xc(%ebp),%eax
  36:	89 cb                	mov    %ecx,%ebx
  38:	89 df                	mov    %ebx,%edi
  3a:	89 d1                	mov    %edx,%ecx
  3c:	fc                   	cld    
  3d:	f3 aa                	rep stos %al,%es:(%edi)
  3f:	89 ca                	mov    %ecx,%edx
  41:	89 fb                	mov    %edi,%ebx
  43:	89 5d 08             	mov    %ebx,0x8(%ebp)
  46:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  49:	90                   	nop
  4a:	5b                   	pop    %ebx
  4b:	5f                   	pop    %edi
  4c:	5d                   	pop    %ebp
  4d:	c3                   	ret    

0000004e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4e:	55                   	push   %ebp
  4f:	89 e5                	mov    %esp,%ebp
  51:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  54:	8b 45 08             	mov    0x8(%ebp),%eax
  57:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5a:	90                   	nop
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	8d 50 01             	lea    0x1(%eax),%edx
  61:	89 55 08             	mov    %edx,0x8(%ebp)
  64:	8b 55 0c             	mov    0xc(%ebp),%edx
  67:	8d 4a 01             	lea    0x1(%edx),%ecx
  6a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  6d:	0f b6 12             	movzbl (%edx),%edx
  70:	88 10                	mov    %dl,(%eax)
  72:	0f b6 00             	movzbl (%eax),%eax
  75:	84 c0                	test   %al,%al
  77:	75 e2                	jne    5b <strcpy+0xd>
    ;
  return os;
  79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7c:	c9                   	leave  
  7d:	c3                   	ret    

0000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  81:	eb 08                	jmp    8b <strcmp+0xd>
    p++, q++;
  83:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  87:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	0f b6 00             	movzbl (%eax),%eax
  91:	84 c0                	test   %al,%al
  93:	74 10                	je     a5 <strcmp+0x27>
  95:	8b 45 08             	mov    0x8(%ebp),%eax
  98:	0f b6 10             	movzbl (%eax),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	0f b6 00             	movzbl (%eax),%eax
  a1:	38 c2                	cmp    %al,%dl
  a3:	74 de                	je     83 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	0f b6 d0             	movzbl %al,%edx
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	0f b6 00             	movzbl (%eax),%eax
  b4:	0f b6 c0             	movzbl %al,%eax
  b7:	29 c2                	sub    %eax,%edx
  b9:	89 d0                	mov    %edx,%eax
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <strlen>:

uint
strlen(char *s)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ca:	eb 04                	jmp    d0 <strlen+0x13>
  cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	01 d0                	add    %edx,%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 ed                	jne    cc <strlen+0xf>
    ;
  return n;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave  
  e3:	c3                   	ret    

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e7:	8b 45 10             	mov    0x10(%ebp),%eax
  ea:	50                   	push   %eax
  eb:	ff 75 0c             	pushl  0xc(%ebp)
  ee:	ff 75 08             	pushl  0x8(%ebp)
  f1:	e8 32 ff ff ff       	call   28 <stosb>
  f6:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <strchr>:

char*
strchr(const char *s, char c)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	83 ec 04             	sub    $0x4,%esp
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10a:	eb 14                	jmp    120 <strchr+0x22>
    if(*s == c)
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	3a 45 fc             	cmp    -0x4(%ebp),%al
 115:	75 05                	jne    11c <strchr+0x1e>
      return (char*)s;
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	eb 13                	jmp    12f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	84 c0                	test   %al,%al
 128:	75 e2                	jne    10c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12f:	c9                   	leave  
 130:	c3                   	ret    

00000131 <gets>:

char*
gets(char *buf, int max)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13e:	eb 42                	jmp    182 <gets+0x51>
    cc = read(0, &c, 1);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	6a 01                	push   $0x1
 145:	8d 45 ef             	lea    -0x11(%ebp),%eax
 148:	50                   	push   %eax
 149:	6a 00                	push   $0x0
 14b:	e8 1a 02 00 00       	call   36a <read>
 150:	83 c4 10             	add    $0x10,%esp
 153:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 156:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15a:	7e 33                	jle    18f <gets+0x5e>
      break;
    buf[i++] = c;
 15c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15f:	8d 50 01             	lea    0x1(%eax),%edx
 162:	89 55 f4             	mov    %edx,-0xc(%ebp)
 165:	89 c2                	mov    %eax,%edx
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	01 c2                	add    %eax,%edx
 16c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 170:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 172:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 176:	3c 0a                	cmp    $0xa,%al
 178:	74 16                	je     190 <gets+0x5f>
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	3c 0d                	cmp    $0xd,%al
 180:	74 0e                	je     190 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	83 c0 01             	add    $0x1,%eax
 188:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18b:	7c b3                	jl     140 <gets+0xf>
 18d:	eb 01                	jmp    190 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 18f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 190:	8b 55 f4             	mov    -0xc(%ebp),%edx
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	01 d0                	add    %edx,%eax
 198:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19e:	c9                   	leave  
 19f:	c3                   	ret    

000001a0 <stat>:

int
stat(char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a6:	83 ec 08             	sub    $0x8,%esp
 1a9:	6a 00                	push   $0x0
 1ab:	ff 75 08             	pushl  0x8(%ebp)
 1ae:	e8 df 01 00 00       	call   392 <open>
 1b3:	83 c4 10             	add    $0x10,%esp
 1b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bd:	79 07                	jns    1c6 <stat+0x26>
    return -1;
 1bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c4:	eb 25                	jmp    1eb <stat+0x4b>
  r = fstat(fd, st);
 1c6:	83 ec 08             	sub    $0x8,%esp
 1c9:	ff 75 0c             	pushl  0xc(%ebp)
 1cc:	ff 75 f4             	pushl  -0xc(%ebp)
 1cf:	e8 d6 01 00 00       	call   3aa <fstat>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1da:	83 ec 0c             	sub    $0xc,%esp
 1dd:	ff 75 f4             	pushl  -0xc(%ebp)
 1e0:	e8 95 01 00 00       	call   37a <close>
 1e5:	83 c4 10             	add    $0x10,%esp
  return r;
 1e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1eb:	c9                   	leave  
 1ec:	c3                   	ret    

000001ed <atoi>:

int
atoi(const char *s)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 1fa:	eb 04                	jmp    200 <atoi+0x13>
 1fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	3c 20                	cmp    $0x20,%al
 208:	74 f2                	je     1fc <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	3c 2d                	cmp    $0x2d,%al
 212:	75 07                	jne    21b <atoi+0x2e>
 214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 219:	eb 05                	jmp    220 <atoi+0x33>
 21b:	b8 01 00 00 00       	mov    $0x1,%eax
 220:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	3c 2b                	cmp    $0x2b,%al
 22b:	74 0a                	je     237 <atoi+0x4a>
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 2d                	cmp    $0x2d,%al
 235:	75 2b                	jne    262 <atoi+0x75>
    s++;
 237:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 23b:	eb 25                	jmp    262 <atoi+0x75>
    n = n*10 + *s++ - '0';
 23d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 240:	89 d0                	mov    %edx,%eax
 242:	c1 e0 02             	shl    $0x2,%eax
 245:	01 d0                	add    %edx,%eax
 247:	01 c0                	add    %eax,%eax
 249:	89 c1                	mov    %eax,%ecx
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	8d 50 01             	lea    0x1(%eax),%edx
 251:	89 55 08             	mov    %edx,0x8(%ebp)
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	0f be c0             	movsbl %al,%eax
 25a:	01 c8                	add    %ecx,%eax
 25c:	83 e8 30             	sub    $0x30,%eax
 25f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	3c 2f                	cmp    $0x2f,%al
 26a:	7e 0a                	jle    276 <atoi+0x89>
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	0f b6 00             	movzbl (%eax),%eax
 272:	3c 39                	cmp    $0x39,%al
 274:	7e c7                	jle    23d <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 276:	8b 45 f8             	mov    -0x8(%ebp),%eax
 279:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <atoo>:

int
atoo(const char *s)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 285:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 28c:	eb 04                	jmp    292 <atoo+0x13>
 28e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	3c 20                	cmp    $0x20,%al
 29a:	74 f2                	je     28e <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	3c 2d                	cmp    $0x2d,%al
 2a4:	75 07                	jne    2ad <atoo+0x2e>
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 05                	jmp    2b2 <atoo+0x33>
 2ad:	b8 01 00 00 00       	mov    $0x1,%eax
 2b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	3c 2b                	cmp    $0x2b,%al
 2bd:	74 0a                	je     2c9 <atoo+0x4a>
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	3c 2d                	cmp    $0x2d,%al
 2c7:	75 27                	jne    2f0 <atoo+0x71>
    s++;
 2c9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 2cd:	eb 21                	jmp    2f0 <atoo+0x71>
    n = n*8 + *s++ - '0';
 2cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	8d 50 01             	lea    0x1(%eax),%edx
 2df:	89 55 08             	mov    %edx,0x8(%ebp)
 2e2:	0f b6 00             	movzbl (%eax),%eax
 2e5:	0f be c0             	movsbl %al,%eax
 2e8:	01 c8                	add    %ecx,%eax
 2ea:	83 e8 30             	sub    $0x30,%eax
 2ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	0f b6 00             	movzbl (%eax),%eax
 2f6:	3c 2f                	cmp    $0x2f,%al
 2f8:	7e 0a                	jle    304 <atoo+0x85>
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 37                	cmp    $0x37,%al
 302:	7e cb                	jle    2cf <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 304:	8b 45 f8             	mov    -0x8(%ebp),%eax
 307:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 30b:	c9                   	leave  
 30c:	c3                   	ret    

0000030d <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 30d:	55                   	push   %ebp
 30e:	89 e5                	mov    %esp,%ebp
 310:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 319:	8b 45 0c             	mov    0xc(%ebp),%eax
 31c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 31f:	eb 17                	jmp    338 <memmove+0x2b>
    *dst++ = *src++;
 321:	8b 45 fc             	mov    -0x4(%ebp),%eax
 324:	8d 50 01             	lea    0x1(%eax),%edx
 327:	89 55 fc             	mov    %edx,-0x4(%ebp)
 32a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32d:	8d 4a 01             	lea    0x1(%edx),%ecx
 330:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 333:	0f b6 12             	movzbl (%edx),%edx
 336:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 338:	8b 45 10             	mov    0x10(%ebp),%eax
 33b:	8d 50 ff             	lea    -0x1(%eax),%edx
 33e:	89 55 10             	mov    %edx,0x10(%ebp)
 341:	85 c0                	test   %eax,%eax
 343:	7f dc                	jg     321 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 345:	8b 45 08             	mov    0x8(%ebp),%eax
}
 348:	c9                   	leave  
 349:	c3                   	ret    

0000034a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34a:	b8 01 00 00 00       	mov    $0x1,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <exit>:
SYSCALL(exit)
 352:	b8 02 00 00 00       	mov    $0x2,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <wait>:
SYSCALL(wait)
 35a:	b8 03 00 00 00       	mov    $0x3,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <pipe>:
SYSCALL(pipe)
 362:	b8 04 00 00 00       	mov    $0x4,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <read>:
SYSCALL(read)
 36a:	b8 05 00 00 00       	mov    $0x5,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <write>:
SYSCALL(write)
 372:	b8 10 00 00 00       	mov    $0x10,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <close>:
SYSCALL(close)
 37a:	b8 15 00 00 00       	mov    $0x15,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <kill>:
SYSCALL(kill)
 382:	b8 06 00 00 00       	mov    $0x6,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <exec>:
SYSCALL(exec)
 38a:	b8 07 00 00 00       	mov    $0x7,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <open>:
SYSCALL(open)
 392:	b8 0f 00 00 00       	mov    $0xf,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mknod>:
SYSCALL(mknod)
 39a:	b8 11 00 00 00       	mov    $0x11,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <unlink>:
SYSCALL(unlink)
 3a2:	b8 12 00 00 00       	mov    $0x12,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <fstat>:
SYSCALL(fstat)
 3aa:	b8 08 00 00 00       	mov    $0x8,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <link>:
SYSCALL(link)
 3b2:	b8 13 00 00 00       	mov    $0x13,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mkdir>:
SYSCALL(mkdir)
 3ba:	b8 14 00 00 00       	mov    $0x14,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <chdir>:
SYSCALL(chdir)
 3c2:	b8 09 00 00 00       	mov    $0x9,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <dup>:
SYSCALL(dup)
 3ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <getpid>:
SYSCALL(getpid)
 3d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <sbrk>:
SYSCALL(sbrk)
 3da:	b8 0c 00 00 00       	mov    $0xc,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <sleep>:
SYSCALL(sleep)
 3e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <uptime>:
SYSCALL(uptime)
 3ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <halt>:
SYSCALL(halt)
 3f2:	b8 16 00 00 00       	mov    $0x16,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fa:	55                   	push   %ebp
 3fb:	89 e5                	mov    %esp,%ebp
 3fd:	83 ec 18             	sub    $0x18,%esp
 400:	8b 45 0c             	mov    0xc(%ebp),%eax
 403:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 406:	83 ec 04             	sub    $0x4,%esp
 409:	6a 01                	push   $0x1
 40b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 40e:	50                   	push   %eax
 40f:	ff 75 08             	pushl  0x8(%ebp)
 412:	e8 5b ff ff ff       	call   372 <write>
 417:	83 c4 10             	add    $0x10,%esp
}
 41a:	90                   	nop
 41b:	c9                   	leave  
 41c:	c3                   	ret    

0000041d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41d:	55                   	push   %ebp
 41e:	89 e5                	mov    %esp,%ebp
 420:	53                   	push   %ebx
 421:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 424:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 42f:	74 17                	je     448 <printint+0x2b>
 431:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 435:	79 11                	jns    448 <printint+0x2b>
    neg = 1;
 437:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43e:	8b 45 0c             	mov    0xc(%ebp),%eax
 441:	f7 d8                	neg    %eax
 443:	89 45 ec             	mov    %eax,-0x14(%ebp)
 446:	eb 06                	jmp    44e <printint+0x31>
  } else {
    x = xx;
 448:	8b 45 0c             	mov    0xc(%ebp),%eax
 44b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 44e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 455:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 458:	8d 41 01             	lea    0x1(%ecx),%eax
 45b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 45e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 461:	8b 45 ec             	mov    -0x14(%ebp),%eax
 464:	ba 00 00 00 00       	mov    $0x0,%edx
 469:	f7 f3                	div    %ebx
 46b:	89 d0                	mov    %edx,%eax
 46d:	0f b6 80 0c 0b 00 00 	movzbl 0xb0c(%eax),%eax
 474:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 478:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47e:	ba 00 00 00 00       	mov    $0x0,%edx
 483:	f7 f3                	div    %ebx
 485:	89 45 ec             	mov    %eax,-0x14(%ebp)
 488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48c:	75 c7                	jne    455 <printint+0x38>
  if(neg)
 48e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 492:	74 2d                	je     4c1 <printint+0xa4>
    buf[i++] = '-';
 494:	8b 45 f4             	mov    -0xc(%ebp),%eax
 497:	8d 50 01             	lea    0x1(%eax),%edx
 49a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a2:	eb 1d                	jmp    4c1 <printint+0xa4>
    putc(fd, buf[i]);
 4a4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4aa:	01 d0                	add    %edx,%eax
 4ac:	0f b6 00             	movzbl (%eax),%eax
 4af:	0f be c0             	movsbl %al,%eax
 4b2:	83 ec 08             	sub    $0x8,%esp
 4b5:	50                   	push   %eax
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 3c ff ff ff       	call   3fa <putc>
 4be:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c9:	79 d9                	jns    4a4 <printint+0x87>
    putc(fd, buf[i]);
}
 4cb:	90                   	nop
 4cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4cf:	c9                   	leave  
 4d0:	c3                   	ret    

000004d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d1:	55                   	push   %ebp
 4d2:	89 e5                	mov    %esp,%ebp
 4d4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4de:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e1:	83 c0 04             	add    $0x4,%eax
 4e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ee:	e9 59 01 00 00       	jmp    64c <printf+0x17b>
    c = fmt[i] & 0xff;
 4f3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4f9:	01 d0                	add    %edx,%eax
 4fb:	0f b6 00             	movzbl (%eax),%eax
 4fe:	0f be c0             	movsbl %al,%eax
 501:	25 ff 00 00 00       	and    $0xff,%eax
 506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 509:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50d:	75 2c                	jne    53b <printf+0x6a>
      if(c == '%'){
 50f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 513:	75 0c                	jne    521 <printf+0x50>
        state = '%';
 515:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 51c:	e9 27 01 00 00       	jmp    648 <printf+0x177>
      } else {
        putc(fd, c);
 521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	83 ec 08             	sub    $0x8,%esp
 52a:	50                   	push   %eax
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 c7 fe ff ff       	call   3fa <putc>
 533:	83 c4 10             	add    $0x10,%esp
 536:	e9 0d 01 00 00       	jmp    648 <printf+0x177>
      }
    } else if(state == '%'){
 53b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 53f:	0f 85 03 01 00 00    	jne    648 <printf+0x177>
      if(c == 'd'){
 545:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 549:	75 1e                	jne    569 <printf+0x98>
        printint(fd, *ap, 10, 1);
 54b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	6a 01                	push   $0x1
 552:	6a 0a                	push   $0xa
 554:	50                   	push   %eax
 555:	ff 75 08             	pushl  0x8(%ebp)
 558:	e8 c0 fe ff ff       	call   41d <printint>
 55d:	83 c4 10             	add    $0x10,%esp
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 564:	e9 d8 00 00 00       	jmp    641 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 569:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 56d:	74 06                	je     575 <printf+0xa4>
 56f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 573:	75 1e                	jne    593 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 575:	8b 45 e8             	mov    -0x18(%ebp),%eax
 578:	8b 00                	mov    (%eax),%eax
 57a:	6a 00                	push   $0x0
 57c:	6a 10                	push   $0x10
 57e:	50                   	push   %eax
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 96 fe ff ff       	call   41d <printint>
 587:	83 c4 10             	add    $0x10,%esp
        ap++;
 58a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58e:	e9 ae 00 00 00       	jmp    641 <printf+0x170>
      } else if(c == 's'){
 593:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 597:	75 43                	jne    5dc <printf+0x10b>
        s = (char*)*ap;
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a9:	75 25                	jne    5d0 <printf+0xff>
          s = "(null)";
 5ab:	c7 45 f4 9d 08 00 00 	movl   $0x89d,-0xc(%ebp)
        while(*s != 0){
 5b2:	eb 1c                	jmp    5d0 <printf+0xff>
          putc(fd, *s);
 5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b7:	0f b6 00             	movzbl (%eax),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	83 ec 08             	sub    $0x8,%esp
 5c0:	50                   	push   %eax
 5c1:	ff 75 08             	pushl  0x8(%ebp)
 5c4:	e8 31 fe ff ff       	call   3fa <putc>
 5c9:	83 c4 10             	add    $0x10,%esp
          s++;
 5cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d3:	0f b6 00             	movzbl (%eax),%eax
 5d6:	84 c0                	test   %al,%al
 5d8:	75 da                	jne    5b4 <printf+0xe3>
 5da:	eb 65                	jmp    641 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5dc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e0:	75 1d                	jne    5ff <printf+0x12e>
        putc(fd, *ap);
 5e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	83 ec 08             	sub    $0x8,%esp
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 04 fe ff ff       	call   3fa <putc>
 5f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fd:	eb 42                	jmp    641 <printf+0x170>
      } else if(c == '%'){
 5ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 603:	75 17                	jne    61c <printf+0x14b>
        putc(fd, c);
 605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	83 ec 08             	sub    $0x8,%esp
 60e:	50                   	push   %eax
 60f:	ff 75 08             	pushl  0x8(%ebp)
 612:	e8 e3 fd ff ff       	call   3fa <putc>
 617:	83 c4 10             	add    $0x10,%esp
 61a:	eb 25                	jmp    641 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61c:	83 ec 08             	sub    $0x8,%esp
 61f:	6a 25                	push   $0x25
 621:	ff 75 08             	pushl  0x8(%ebp)
 624:	e8 d1 fd ff ff       	call   3fa <putc>
 629:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 62c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62f:	0f be c0             	movsbl %al,%eax
 632:	83 ec 08             	sub    $0x8,%esp
 635:	50                   	push   %eax
 636:	ff 75 08             	pushl  0x8(%ebp)
 639:	e8 bc fd ff ff       	call   3fa <putc>
 63e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 641:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 648:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 64c:	8b 55 0c             	mov    0xc(%ebp),%edx
 64f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 652:	01 d0                	add    %edx,%eax
 654:	0f b6 00             	movzbl (%eax),%eax
 657:	84 c0                	test   %al,%al
 659:	0f 85 94 fe ff ff    	jne    4f3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 65f:	90                   	nop
 660:	c9                   	leave  
 661:	c3                   	ret    

00000662 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 662:	55                   	push   %ebp
 663:	89 e5                	mov    %esp,%ebp
 665:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 668:	8b 45 08             	mov    0x8(%ebp),%eax
 66b:	83 e8 08             	sub    $0x8,%eax
 66e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	a1 28 0b 00 00       	mov    0xb28,%eax
 676:	89 45 fc             	mov    %eax,-0x4(%ebp)
 679:	eb 24                	jmp    69f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 683:	77 12                	ja     697 <free+0x35>
 685:	8b 45 f8             	mov    -0x8(%ebp),%eax
 688:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68b:	77 24                	ja     6b1 <free+0x4f>
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 695:	77 1a                	ja     6b1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a5:	76 d4                	jbe    67b <free+0x19>
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6af:	76 ca                	jbe    67b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	8b 40 04             	mov    0x4(%eax),%eax
 6b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	01 c2                	add    %eax,%edx
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	8b 00                	mov    (%eax),%eax
 6c8:	39 c2                	cmp    %eax,%edx
 6ca:	75 24                	jne    6f0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	8b 50 04             	mov    0x4(%eax),%edx
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	8b 00                	mov    (%eax),%eax
 6d7:	8b 40 04             	mov    0x4(%eax),%eax
 6da:	01 c2                	add    %eax,%edx
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 00                	mov    (%eax),%eax
 6e7:	8b 10                	mov    (%eax),%edx
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	89 10                	mov    %edx,(%eax)
 6ee:	eb 0a                	jmp    6fa <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 10                	mov    (%eax),%edx
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 40 04             	mov    0x4(%eax),%eax
 700:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	01 d0                	add    %edx,%eax
 70c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70f:	75 20                	jne    731 <free+0xcf>
    p->s.size += bp->s.size;
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 50 04             	mov    0x4(%eax),%edx
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	8b 40 04             	mov    0x4(%eax),%eax
 71d:	01 c2                	add    %eax,%edx
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	8b 10                	mov    (%eax),%edx
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	89 10                	mov    %edx,(%eax)
 72f:	eb 08                	jmp    739 <free+0xd7>
  } else
    p->s.ptr = bp;
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 55 f8             	mov    -0x8(%ebp),%edx
 737:	89 10                	mov    %edx,(%eax)
  freep = p;
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	a3 28 0b 00 00       	mov    %eax,0xb28
}
 741:	90                   	nop
 742:	c9                   	leave  
 743:	c3                   	ret    

00000744 <morecore>:

static Header*
morecore(uint nu)
{
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 751:	77 07                	ja     75a <morecore+0x16>
    nu = 4096;
 753:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	c1 e0 03             	shl    $0x3,%eax
 760:	83 ec 0c             	sub    $0xc,%esp
 763:	50                   	push   %eax
 764:	e8 71 fc ff ff       	call   3da <sbrk>
 769:	83 c4 10             	add    $0x10,%esp
 76c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 76f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 773:	75 07                	jne    77c <morecore+0x38>
    return 0;
 775:	b8 00 00 00 00       	mov    $0x0,%eax
 77a:	eb 26                	jmp    7a2 <morecore+0x5e>
  hp = (Header*)p;
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 782:	8b 45 f0             	mov    -0x10(%ebp),%eax
 785:	8b 55 08             	mov    0x8(%ebp),%edx
 788:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78e:	83 c0 08             	add    $0x8,%eax
 791:	83 ec 0c             	sub    $0xc,%esp
 794:	50                   	push   %eax
 795:	e8 c8 fe ff ff       	call   662 <free>
 79a:	83 c4 10             	add    $0x10,%esp
  return freep;
 79d:	a1 28 0b 00 00       	mov    0xb28,%eax
}
 7a2:	c9                   	leave  
 7a3:	c3                   	ret    

000007a4 <malloc>:

void*
malloc(uint nbytes)
{
 7a4:	55                   	push   %ebp
 7a5:	89 e5                	mov    %esp,%ebp
 7a7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7aa:	8b 45 08             	mov    0x8(%ebp),%eax
 7ad:	83 c0 07             	add    $0x7,%eax
 7b0:	c1 e8 03             	shr    $0x3,%eax
 7b3:	83 c0 01             	add    $0x1,%eax
 7b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b9:	a1 28 0b 00 00       	mov    0xb28,%eax
 7be:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c5:	75 23                	jne    7ea <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c7:	c7 45 f0 20 0b 00 00 	movl   $0xb20,-0x10(%ebp)
 7ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d1:	a3 28 0b 00 00       	mov    %eax,0xb28
 7d6:	a1 28 0b 00 00       	mov    0xb28,%eax
 7db:	a3 20 0b 00 00       	mov    %eax,0xb20
    base.s.size = 0;
 7e0:	c7 05 24 0b 00 00 00 	movl   $0x0,0xb24
 7e7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ed:	8b 00                	mov    (%eax),%eax
 7ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 40 04             	mov    0x4(%eax),%eax
 7f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fb:	72 4d                	jb     84a <malloc+0xa6>
      if(p->s.size == nunits)
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 40 04             	mov    0x4(%eax),%eax
 803:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 806:	75 0c                	jne    814 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	8b 10                	mov    (%eax),%edx
 80d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 810:	89 10                	mov    %edx,(%eax)
 812:	eb 26                	jmp    83a <malloc+0x96>
      else {
        p->s.size -= nunits;
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	8b 40 04             	mov    0x4(%eax),%eax
 81a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 81d:	89 c2                	mov    %eax,%edx
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	8b 40 04             	mov    0x4(%eax),%eax
 82b:	c1 e0 03             	shl    $0x3,%eax
 82e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	8b 55 ec             	mov    -0x14(%ebp),%edx
 837:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83d:	a3 28 0b 00 00       	mov    %eax,0xb28
      return (void*)(p + 1);
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	83 c0 08             	add    $0x8,%eax
 848:	eb 3b                	jmp    885 <malloc+0xe1>
    }
    if(p == freep)
 84a:	a1 28 0b 00 00       	mov    0xb28,%eax
 84f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 852:	75 1e                	jne    872 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 854:	83 ec 0c             	sub    $0xc,%esp
 857:	ff 75 ec             	pushl  -0x14(%ebp)
 85a:	e8 e5 fe ff ff       	call   744 <morecore>
 85f:	83 c4 10             	add    $0x10,%esp
 862:	89 45 f4             	mov    %eax,-0xc(%ebp)
 865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 869:	75 07                	jne    872 <malloc+0xce>
        return 0;
 86b:	b8 00 00 00 00       	mov    $0x0,%eax
 870:	eb 13                	jmp    885 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	89 45 f0             	mov    %eax,-0x10(%ebp)
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	8b 00                	mov    (%eax),%eax
 87d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 880:	e9 6d ff ff ff       	jmp    7f2 <malloc+0x4e>
}
 885:	c9                   	leave  
 886:	c3                   	ret    

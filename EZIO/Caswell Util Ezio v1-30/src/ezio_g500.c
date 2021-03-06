#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "include/lcd_ctrl.h"
#ifdef EZIO_G500_CONFIG
void print_help(void)
{
	printf("\n");
	printf("Usage: slcmap -d [device] -b [baudrate] -[command]\n");
	printf("  [device]\n");
	printf("\texample: /dev/ttyS0\n");
	printf("  [baudrate]\n");
	printf("\texample: 115200\n");
	printf("  [command]\n");
	printf("\t -S   \"...\"  \t\t\tDisplay message\n");
	printf("\t -G   [Mode]  [Bmp path]  \tDisplay bmp, Mode=0:192*64, Mode=1:128*64, Mode=2:128*32\n");
	printf("\t -C            \t\t\tClear screen\n");
	printf("\t -c          	 \t\tClear cursor line\n");
	printf("\t -H          	 \t\tHome cursor\n");
	printf("\t -g          	 \t\tKeypad function test\n");
	printf("\t -s   [1/0]    \t\t\tSet cursor ON/OFF\n");
	printf("\t -P   x  y     \t\t\tSet cursor position,  x=00~0F , y=00~03	\n");
	printf("\t -L          	 \t\tMove cursor left\n");
	printf("\t -R          	 \t\tMove cursor right\n");
	printf("\t -l          	 \t\tMove cursor to left-most\n");
	printf("\t -r          	 \t\tMove cursor to right-most\n");
	printf("\t -U          	 \t\tMove cursor up\n");
	printf("\t -D          	 \t\tMove cursor down\n");
	printf("\t -B   [baudrate] \t\tChange device baudrate\n");
	printf("\t -K   [Light]    \t\tSet back light,	Light=00~07\n");
	printf("\t -h          	 \t\tHelp\n");
	printf("\n");
}

int get_key(unsigned int fd){
	int res;
	unsigned char buf[1]={0x00};
	Cls(fd);
	while (1)
	{
	memset(buf,0x00,sizeof(buf));
	res = read(fd,buf,1);		/* read response from EZIO   */
		switch(buf[0]) {		/* Switch the Read command   */
		case 0x41 :      
			Cls(fd);
			SendString(fd,MSG1,strlen(MSG1)); 
			Home(fd);
		break;
		case 0x42 :  
			Cls(fd);
			SendString(fd,MSG2,strlen(MSG2)); 
			Home(fd);
			break;
		case 0x43 :          
			Cls(fd);
			SendString(fd,MSG3,strlen(MSG3)); 
			Home(fd);
		break;
		case 0x44 :  
			Cls(fd);
			SendString(fd,MSG4,strlen(MSG4)); 
			Home(fd);
		break;
		case 0x45 : 
			Cls(fd);
			SendString(fd,MSG5,strlen(MSG5)); 
			Home(fd);
		break;
		case 0x46 :
			Cls(fd);
			SendString(fd,MSG6,strlen(MSG6)); 
			Home(fd);
		break;
		case 0x47 :     
			Cls(fd);
			SendString(fd,MSG7,strlen(MSG7)); 
			Home(fd);
		break;
		}	
	}
	return 0;
}

unsigned char Str2Hex(char *str){
	int i;
	unsigned char value,tmp;

	for (i=0;i<2;i++){
		tmp=str[i];
		if (tmp>='0' && tmp<='9')
			tmp=tmp-'0';
		else if (tmp>='a' && tmp<='f')
			tmp=tmp-'a'+10;
		else if (tmp>='A' && tmp<='F')
			tmp=tmp-'A'+10;
		else{
			value=0xFF;
			break;
		}

		if (i==0)
			value=tmp << 4;
		else 
			value=value+tmp;

	}
	return value;
}

int main (int argc,char *argv[]) {
	int fd=0,c=0;
		
	if(argc<6){
		print_help();
		return 0;
	}

	fd=OpenAdrPort(argv[2],atol(argv[4]));
	
LOOP:
	while ((c = getopt (argc, argv, "d:b:S:G:CcHs:P:LRlrgUDB:K:h")) != -1)
	switch (c)
	{
		case 'g':
			get_key(fd);				// Read key
			break;
		case 'S':
			if (argc==6)
				print_help();
			else
				SendString(fd, argv[6], strlen(argv[6])); 
			break;
		case 'G':
			if (argc<=7)
				print_help();
			else
				SendPic(fd, atoi(argv[6]), argv[7]); 
			break;
		case 'C':
			Cls(fd);				//Clear screen
			break;
		case 'c':
			Can(fd);				//Clear cursor line
			break;
		case 'H':
			Home(fd);				//Home cursor
			break;
		case 's':
			if (argc==6)
				print_help();
			else{
				if (argv[6][0] == '0')
					Hide(fd);
				else
					Show(fd);
			}
			break;
		case 'P':
			if (argc<=7)
				print_help();
			else
				MoveCurPosition(fd, Str2Hex(argv[6]), Str2Hex(argv[7])); 
			break;
		case 'L':
			MoveL(fd);				//Move cursor left
			break;
		case 'R':
			MoveR(fd);				//Move cursor right
			break;
		case 'l':
			MoveLMost(fd);				//Move cursor to left-most
			break;
		case 'r':
			MoveRMost(fd);				//Move cursor to right-most
			break;
		case 'U':
			MoveU(fd);				//Move cursor up
			break;
		case 'D':					//Move cursor down
			MoveD(fd);
			break;
		case 'B':					//Change baudrate
			if (argc==6)
				print_help();
			else
				ChangeBaudrate(fd, atol(argv[6])); 
			break;	
		case 'K':					//Set back light
			if (argc==6)
				print_help();
			else
				SetBackLight(fd, Str2Hex(argv[6])); 
			break;
		case 'h':					//Help
			print_help();
			break;
		case 'd':					//set devices			
			goto LOOP;
		case 'b':					//set baudrate
			goto LOOP;
		default:
			print_help();
			break;
	}

	CloseAdrPort(fd);					
	return 0;

}
#else
int main (int argc,char *argv[]) {
                return 0;
}
#endif

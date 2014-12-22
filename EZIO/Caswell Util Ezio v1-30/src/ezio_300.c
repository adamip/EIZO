#include "include/lcd_ctrl.h"
#ifdef EZIO_300_CONFIG
void print_help(void)
{
	printf("\n");

        printf("ezio_300_api - The Caswell EZIO sample API\n");
	printf("Usage: ezio_300_api -d [device] -[command]\n");
	printf("[device]\n");
	printf("\texample: /dev/ttyS0\n");
	printf("[command]\n");
	printf("\t -g                  Read key\n");
	printf("\t -s [Line] [Message] Display message\n");
	printf("\t -c                  Clear screen\n");
	printf("\t -o                  Home cursor\n");
	printf("\t -L                  Move cursor 1 character left\n");
	printf("\t -R                  Move cursor 1 character right\n");
	printf("\t -l                  Scroll 1 character left\n");
	printf("\t -r                  Scroll 1 character right\n");
	printf("\t -i                  Hide cursor & display blanked characters\n");
	printf("\t -t                  Turn on (blinking block cursor)\n");
	printf("\t -S                  Show underline cursor\n");
	printf("\t -n                  Send noise message\n");
	printf("\t -h                  Show help message\n\n");
	printf("\t -p [Information]    Create customized pattern\n");
	printf("\t [Line]:    (1|2) Display in the (1|2) lines\n");
	printf("\t [Message]: display string, string length limit of 16 \n");
	printf("\t [Information]: get save address and row types,");
	printf("\t                need 18 characters, more in README\n");
	printf("\n");
}

int get_key(unsigned int fd){
	int res;
	unsigned char buf[3]={0x00},old_status=0x00;
	SetDis(fd);
	while (1)
	{
		ReadKey(fd);
		memset(buf,0x00,sizeof(buf));
		res = read(fd,buf,2);			/* read response from EZIO   */
		switch(buf[1]) {			/* Switch the Read command   */
		case 0xbe :				/* Up Botton was received    */
			if(old_status==0xbe)
				break;
			ShowMessage(fd,MSG1,MSG3);	/* display "Portwell EZIO"   */
			sleep(1);			/* display "Up is selected   */
			old_status=0xbe;
			break;
		case 0xbd :				/* Down Botton was received  */
                        if(old_status==0xbd)
                                break;
			ShowMessage(fd,MSG1,MSG4);	/* display "Portwell EZIO"   */
			sleep(1);			/* display "Down is selected */
			old_status=0xbd;
			break;
		case 0xbb :				/* Enter Botton was received */
                        if(old_status==0xb7)
                                break;
			ShowMessage(fd,MSG1,MSG5);	/* display "Portwell EZIO"   */
			sleep(1);			/* display "Enter is selected*/
			old_status=0xb7;
			break;			
		case 0xb7 :				/* ESC   Botton was received */
                        if(old_status==0xbb)
                                break;
			ShowMessage(fd,MSG1,MSG6);	/* display "Portwell EZIO"   */
			sleep(1);			/* display "Esc is selected  */
			old_status=0xbb;
			break;
		default:
			ShowMessage(fd,MSG1,MSG2); 	/* display "Portwell EZIO"   */
			old_status=0xfb;
		}
	}
	return 0;
}

void show_message(unsigned int fd,char* LINE1,char* LINE2)
{
	int CLINE1=strlen(LINE1);
	int CLINE2=strlen(LINE2);
	if((CLINE1!=0)&&(CLINE2==0))
	{
		ShowMessage_1(fd,_NULL);
		ShowMessage_1(fd,LINE1);
	}
	else if ((CLINE1==0)&&(CLINE2!=0))
	{
		ShowMessage_2(fd,_NULL);
		ShowMessage_2(fd,LINE2);
	}
	else
	{
		ShowMessage(fd,_NULL,_NULL);
		ShowMessage(fd,LINE1,LINE2);
	}
}

int main (int argc,char *argv[]) {
	int fd=0,c=0;

	if(argc == 3)      //Send noise before init command.
	{
		if (argv[1][1] == 'n')
		{
			fd=OpenAdrPort(argv[2],2400);
			SendNoiseInit(fd);
			return 0;
		}
	}

	if(argc<4)
	{
		print_help();
		return 0;
	}
	fd=OpenAdrPort(argv[2],2400);
	Init(fd);
	Hide(fd);
LOOP:
	while ((c = getopt (argc, argv, "d:s:STghctioLRlrp")) != -1)
	switch (c)
	{
		case 'g':
			get_key(fd);				//Read key
			break;
		case 's':
			if (argc==4)
			{
				printf("Please input string\n");
				break;
			}else if(atoi(optarg)==1)
			{
				ShowMessage_1(fd,_NULL);
				ShowMessage_1(fd,argv[5]);
			}else if(atoi(optarg)==2)
                        {
                                ShowMessage_2(fd,_NULL);
                                ShowMessage_2(fd,argv[5]);
			}
			break;
		case 'c':
			Cls(fd);				//Clear screen
			break;
		case 'o':
			Home(fd);				//Home cursor
			break;
		case 'i':
			Hide(fd);				//Hide cursor & display blanked characters
			break;
		case 't':
			TurnOn(fd);				//Turn on (blinking block cursor)
			break;
		case 'L':
			MoveL(fd);				//Move cursor 1 character left
			break;
		case 'R':
			MoveR(fd);				//Move cursor 1 character right
			break;
		case 'l':
			ScrollL(fd);				//Scroll 1 character left
			break;
		case 'r':
			ScrollR(fd);				//Scroll 1 character right
			break;
		case 'S':
			Show(fd);				//Show underline cursor
			break;
		case 'T':
			ReadKey(fd);				//test mode(Read_KEY)
			break;
		case 'h':
			print_help();
			return 0;
		case 'd':						
			goto LOOP;
		case 'b':						
			goto LOOP;			
		case 'p':
			Paint(fd,argv[4]);
			break;
		default:
			print_help();
			return 0;
	}

	CloseAdrPort(fd);					
	return 0;
 
}
#else
int main (int argc,char *argv[]) {
	return 0;
}
#endif 

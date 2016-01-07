int main(){

return 0;
}


unsigned int a_to_octal(char *s){
	register unsigned int value = 0;
	while((*s>='0')&&(*s<='7')){
		value = (value << 3) + (*s - '0');
		s++;
	}
	return value;
}


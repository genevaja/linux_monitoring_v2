// # "ip [любые корректные]"
// # "Коды ответа (200, 201, 400, 401, 403, 404, 500, 501, 502, 503)"
// # "Методы (GET, POST, PUT, PATCH, DELETE)"
// # "Даты (в рамках заданного дня лога, должны идти по увеличению)"
// # "URL запрос агента"
// # "Агенты (Mozilla, Google Chrome, Opera, Safari, Internet Explorer, Microsoft Edge, Crawler and bot, Library and net tool)"

// echo -e "$ip\t $date\t $time\t $method\t $path\t $code\t $bytes\t $url\t \"$agent\"" >> "$filename"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

char *generate_ip(char *string);
char *generate_date(char *string, int date);
char *generate_time(char *string);
char *generate_time_zone(char *string);
char *generate_method(char *string);
char *generate_path(char *string);
char *generate_resp_code(char *string);
char *generate_bytes(char *string);
char *generate_url(char *string);
char *generate_agent(char *string);

int main () {
  for (int j = 1; j < 6; j++) {
    char file_name[20] = {'\0'};
    sprintf(file_name, "%d", j);
    strcat(file_name, ".log");
    FILE *fp = NULL;
    fp = fopen(file_name, "w");
    if (!fp) {
      perror(file_name);
      exit(1);
    }
    char *string = (char*)malloc(sizeof(char) * 2048);
    if (!string) {
        fclose(fp);
        return 1;
    }
    for (int i = 0; i < (50 + rand() % (100 - 50 + 1)); i++) {
      memset(string, '\0', (sizeof(char) * 2048));
      string = generate_ip(string);
      strcat(string, "- - [");
      string = generate_date(string, 20 + j);
      string = generate_time(string);
      string = generate_time_zone(string);
      string = generate_method(string);
      string = generate_path(string);
      string = generate_resp_code(string);
      string = generate_bytes(string);
      string = generate_url(string);
      string = generate_agent(string);
      fprintf(fp, "%s\n", string);
    }
    free(string);
    fclose(fp);
  }
  return 0;
}

// # "Агенты (Mozilla, Google Chrome, Opera, Safari, Internet Explorer, Microsoft Edge, Crawler and bot, Library and net tool)"
char *generate_agent(char *string) {
  char agents[10][21] = {"Mozilla", "Google Chrome", "Opera", "Safari",
                        "Internet Explorer", "Microsoft Edge", "Crawler", "Bot", 
                        "Library", "Net tool"};
  char temp[50] = {'\0'};
  temp[0] = '"';
  strcat(temp, agents[rand() % 10]);
  strcat(temp, "\"");
  strcat(string, temp);
  return string;
}

char *generate_url(char *string) {
  char preambula[200] = "\"https://genevaja.com/";
  char temp[100] = {'\0'};
  int i = 0;
  for (; i < 20; i++) {
    temp[i] =  97 + rand() % (122 - 97 + 1);
  }
  temp[i] = '/';
  i++;
  temp[i] = '\"';
  i++;
  temp[i] = ' ';
  strcat(preambula, temp);
  strcat(string, preambula);
  return string;
}

char *generate_bytes(char *string) {
  char temp[100] = {'\0'};
  sprintf(temp, "%d ", rand() % 100 + 1);
  strcat(string, temp);
  return string;
}
  


char *generate_path(char *string) {
  // 65-90
  // 97-122
  char temp[100] = {'\0'};
  int i = 1;
  temp[0] = '/';
  for (; i < 10; i++) {
    temp[i] =  65 + rand() % (90 - 65 + 1);
  }
  temp[i] = '/';
  i++;
  for (; i < 20; i++) {
    temp[i] =  97 + rand() % (122 - 97 + 1);
  }
  temp[i] = '\"';
  i++;
  temp[i] = ' ';
  strcat(string, temp);

  return string;
}

char *generate_ip(char *string) {
  char temp[20] = {'\0'};
  sprintf(temp, "%d.%d.%d.%d ", 
          rand() % 9 + 1, rand() % 255, rand() % 255, rand() % 250 + 2);
  strcat(string, temp);
  return string;
}

//  200-299 success
//  400-499 client error
//  500-599 server error
// https://developer.mozilla.org/ru/docs/Web/HTTP/Status
char *generate_resp_code(char *string) {
    const char codes[10][5] = {"200 ", "201 ", "400 ", "401 ", "403 ", "404 ",
                               "500 ", "501 ", "502 ", "503 "};
    strcat(string, codes[rand() % 10]);
    return string;
}

char *generate_method(char *string) {
    const char methods[5][8] = {"GET ", "POST ", "PUT ", "PATCH ", "DELETE "};
    strcat(string, methods[rand() % 5]);
    return string;
}

char *generate_time(char *string) {
    char date[200] = {'\0'};
    FILE *fp2;
    int status;
    char path[200] = {'\0'};

    fp2 = popen("printf %s $(date +%T)", "r");
    if (fp2 == NULL)
        return string;

    while (fgets(path, 200, fp2) != NULL)
        sprintf(date, "%s", path);
        // printf("%s", path);

    status = pclose(fp2);
    if (status == -1) {
        printf("ERROR\n");
    }

    strcat(string, date);
    strcat(string, " ");


    return string;
}

char *generate_time_zone(char *string) {
    char date[200] = {'\0'};
    FILE *fp2;
    int status;
    char path[200] = {'\0'};

    fp2 = popen("printf %s $(date +%z)", "r");
    if (fp2 == NULL)
        return string;

    while (fgets(path, 200, fp2) != NULL)
        sprintf(date, "%s", path);
        // printf("%s", path);

    status = pclose(fp2);
    if (status == -1) {
        printf("ERROR\n");
    }

    strcat(string, date);
    strcat(string, "] \"");


    return string;
}

char *generate_date(char *string, int date) {
    int status;
    char time[200] = {'\0'};
    FILE *fp2;
    char path[200] = {'\0'};
    char command[100] = {'\0'}; 
    sprintf(command, "printf %%s $(date +%d/%%b/%%Y)", date);

    fp2 = popen(command, "r");
    if (fp2 == NULL)
        return string;

    while (fgets(path, 200, fp2) != NULL)
        sprintf(time, "%s", path);
        // printf("%s", path);

    status = pclose(fp2);
    if (status == -1) {
        printf("ERROR\n");
    }

    strcat(string, time);
    strcat(string, ":");

    return string;
}

// 10.0.0.0
// 172.16.0.0 - 172.31.0.0
// 192.168.0.0 - 192.168.255.0

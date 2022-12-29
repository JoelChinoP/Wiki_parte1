#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $q = CGI->new;
my $title = $q->param('title');
print $q->header('text/html; charset=utf-8');

print <<HTML;
<!DOCTYPE html>
<link href="css/style.css" rel="stylesheet" type="text/css">
<html>
  <head>
  <title>Ver</title>
  </head>
HTML

my @registro;
my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("SELECT Text FROM Fakewiki WHERE Title=?");
$sth->execute($title);

my $i = 0;
while( my @row = $sth->fetchrow_array ) {
  @registro = split('-',$row[0]);
  $i++;
}
$sth->finish;

foreach my $linea (@registro){
  $linea =~ s/^\s+//g;
  if($linea =~ /^(#+)(.*)/){
    if($linea =~ /^#{6}(.*)/){
      print "<h6>$1</h6>\n";
    }
    elsif($linea =~ /^#{3}(.*)/){
     print "<h3>$1</h3>\n";
    }
    elsif($linea =~ /^#{2}(.*)/){
     print "<h2>$1</h2>\n";
    }
    elsif($linea =~ /^#{1}(.*)/){
     print "<h1>$1</h1>\n";
    }
  }
  if($linea =~ /^(\*+)(.*)(\*+)$/){
     if($linea =~ /^\*{3}(.*)\*{3}$/){
       print "<p><strong><em>$1</em></strong></p>";
     }
     elsif($linea =~ /^\*{2}(.*)\_(.*)\_(.*)\*{2}$/){
       print "<p><strong>$1<em>$2</em>$3</strong></p>";
     }
     elsif($linea =~ /^\*{2}(.*)\*{2}/){
       print "<p><strong>$1</strong></p>"
     }
     elsif($linea =~ /^\*{1}(.*)\*{1}$/){
       print "<p><em>$1</em></p>";
     }
  }
  if($linea =~ /^~{2}(.*)~{2}$/){
    print "<p><del>$1</del></p>";
  }
  if($linea =~ /^(.*)\[(.*)\]\((.*)\)(.*)/){
   print "<p>$1<a href=$3>$2</a>$4</p>";
  }
  if(!(index($linea, "`") != -1) and !(index($linea, "#") != -1) and !(index($linea, "~") != -1) and !(index($linea, "*") != -1) and !(index($linea, "]") != -1)){
    print "<p>$linea</p>";
  }
  if($linea =~ /^`{3}((\n*.+)*)\n`{3}$/){
    print "<p><code>$1</code></p>";
  }
}
print <<HTML;
</body>
<hr>
<a class=text href="list.pl">Volver al inicio</a>
</html>
HTML

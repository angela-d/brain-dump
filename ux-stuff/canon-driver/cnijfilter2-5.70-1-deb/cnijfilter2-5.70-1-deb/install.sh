#!/bin/bash

##############################################################################
##
##  Canon Inkjet Printer Driver for Linux
##  Copyright CANON INC. 2001-2018
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; version 2 of the License.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
##
##############################################################################

C_version="5.70-1"
C_copyright_end="2018"
C_default_system="deb"

P_support_printer=("TS8200" "XK80" "TS8230" "TS8280" "TS6200" "TS6230" "TS6280" "TS9500" "TR9530" "TS9580" "TR4500" "E4200")

L_INST_COM_01_01="Command executed = %s\n"

L_INST_COM_01_02="An error occurred. The package management system cannot be identified.\n"
L_INST_COM_01_03="An error occurred. A necessary package could not be found in the proper location.\n"
L_INST_COM_01_04="Installation has been completed.\n"
L_INST_COM_01_05="An error occurred. Your environment cannot be identified as 32-bit or 64-bit.\nTry to install again by using the following command.\n"
L_INST_COM_01_06="An error occurred. The specified environment differs from your environment.\nTry to install again by using the following command.\n"

L_INST_COM_02_01="Usage: %s\n"

L_INST_COM_02_02="Uninstallation has been completed.\n"

L_INST_COM_03_01="[Package]\n"


L_INST_PRN_00_01="Canon Inkjet Printer Driver"
L_INST_PRN_00_02="Version %s"
L_INST_PRN_00_03="Copyright CANON INC. %s-%s"

L_INST_PRN_01_01="Register Printer\n"
L_INST_PRN_01_02="Next, register the printer to the computer.\n"
L_INST_PRN_01_03="Connect the printer, and then turn on the power.\nTo use the printer on the network, connect the printer to the network.\nWhen the printer is ready, press the Enter key.\n"

L_INST_PRN_01_04="Connection Method\n"
L_INST_PRN_01_05="USB\n"
L_INST_PRN_01_06="Network\n"
L_INST_PRN_01_07="Select the connection method.%s"

L_INST_PRN_01_08="Searching for printers...\n"

L_INST_PRN_01_09="Select Printer\n"
L_INST_PRN_01_10="Select the printer.\nIf the printer you want to use is not listed, select Update [0] to search again.\nTo cancel the process, enter [Q].\n"
L_INST_PRN_01_11="Update"
L_INST_PRN_01_12="Target printers detected (MAC address  IP address)\n"
L_INST_PRN_01_13="Other printers detected (MAC address  IP address)\n"
L_INST_PRN_01_14="Target printers detected\n"
L_INST_PRN_01_15="Other printers detected\n"
L_INST_PRN_01_16="Currently selected:%s %s\n"

L_INST_PRN_01_17="Enter the value."
L_INST_PRN_01_18="Could not detect the target printer.\n"

L_INST_PRN_01_19="Register Printer\n"
L_INST_PRN_01_20="Enter the printer name.%s"

L_INST_PRN_01_21="The printer name you entered already exists. Do you want to overwrite it?\nEnter [y] for Yes or [n] for No.%s"

L_INST_PRN_01_22="The printer name is invalid.\nYou can only use the following characters for the printer name:\n alphanumeric characters (a-z, A-Z, 0-9), \".\", \"-\", \"_\", \"+\", \"@\"\n"

L_INST_PRN_01_23="Set as Default Printer\n"
L_INST_PRN_01_24="Do you want to set this printer as the default printer?\nEnter [y] for Yes or [n] for No.%s"

L_INST_PRN_01_25="Printer Name : %s\n"

L_INST_PRN_01_26="Select this printer name for printing.\n"
L_INST_PRN_01_27="The printer registration has not been completed.\nRegister the printer manually by using the lpadmin command.\n"

L_INST_PRN_02_01="Uninstall Printer\n"
L_INST_PRN_02_02="All printer registration for this model will be deleted.\n"
L_INST_PRN_02_03="Do you want to continue?\nEnter [y] for Yes or [n] for No.%s"

L_INST_PRN_02_04="Failed to delete [%s].\nAfter the uninstall process is finished, delete this printer manually by using the lpadmin command.\n"
L_INST_PRN_02_05="Failed to delete printers.\nAfter the uninstall process is finished, delete these printers manually by using the lpadmin command.\n"


C_main_module="cnijfilter2"
C_copyright_start="2001"
C_ppdfile_path="/usr/share/cups/model/*"
raster_command="rastertocanonij"

# internalversion : 3.20.01.005

#################################################################
#### C_function name define
#################################################################
C_function01="P_FUNC_MAIN_make_queue"
C_function02="P_FUNC_MAIN_delete_all_queue"
C_function03="P_FUNC_show_copyright"

#################################################################
#### path, filename, commandname, etc.
#################################################################
P_entry_list_path=""
P_all_entry_list_path=""
P_entry_list_path_rpm="/usr/local/share/"
P_entry_list_path_deb="/usr/share/"
P_entry_list_dir="cnijfilter2/"
P_all_entry_list_dir="cnijfilter*/"
P_entry_list_name="cnij_entry"
P_cupsd_command_1="/etc/init.d/cups"
P_cupsd_command_2="/etc/init.d/cupsys"
P_cupsd_command_current=""
P_lpadmin_command_full="/usr/sbin/lpadmin"
P_lpadmin_command_current=""
P_is_std_usb_backend=0
P_ppd_install_path="/usr/share/cups/model/"

#################################################################
#### Show the copyright  $1:version
#################################################################
P_FUNC_show_copyright()
{
#	p_copyright1="Canon Inkjet Printer Driver Ver."$1" for Linux"
#	p_copyright2="Copyright CANON INC. 2001-2011"

#	echo $p_copyright1; echo $p_copyright2; echo $p_copyright3

	printf "$L_INST_PRN_00_01\n"
	printf "$L_INST_PRN_00_02\n" "$1"
	printf "$L_INST_PRN_00_03\n" "$C_copyright_start" "$C_copyright_end"
}

#################################################################
#### Add registered entry name to entry_list_file. $1:entry_list_file name  $2:entry name to add
#################################################################
p_FUNC_write_entrydata_to_file()
{
	local p_local_existentrys=""

	p_local_existentrys=`cat $P_entry_list_fullname`

	#to Upper case
	p_local_name_to_write=`echo "$2" | tr a-z A-Z`
	
	
	# set delimiter
	IFS='
	'
	#-----------------------------
	# Check entry list file (If same name exists, you should not to add entry name)
	#-----------------------------
	for line in ${p_local_existentrys}; do
		if [ -n "$line" ]; then
			#to Upper case
			line=`echo "$line" | tr a-z A-Z`
			
			if [ "$p_local_name_to_write" = "$line" ]; then
				# same name exist in the entry_list_file -> restore delimiter and return.
				IFS=$IFS_ORG
				return 1
			fi
		fi
	done

	# restore delimiter.
	IFS=$IFS_ORG

	# add
	local p_local_entry="'"$2"'"
	${P_printer_sudo_command}sh -c "echo $p_local_entry >> $1"
	
	return 0
	
}

#################################################################
#### Delete registered entry name from entry_list_file. $1:entry name to delete
#################################################################
p_FUNC_delete_entryname_from_file()
{
	local p_local_list_of_files=""
	local p_local_existentrys=""
	local p_local_list_of_entries=""
	local p_local_out_flg=0

	p_local_list_of_files=`ls ${P_all_entry_list_path}/${P_entry_list_name}* 2> /dev/null`

	if [ $? -ne 0 ]; then
		return 1
	fi

	# set delimiter
	IFS='
'

	#to Upper case
	p_local_target_name=`echo "$1" | tr a-z A-Z`

	for file_name in $p_local_list_of_files; do
		p_local_existentrys=`cat $file_name`

		#-----------------------------
		# Check entry list file (If same name exists, you should not to add entry name)
		#-----------------------------
		p_local_out_flg=0
		p_local_list_of_entries=""
		for line in ${p_local_existentrys}; do
			if [ -n "$line" ]; then
				#to Upper case
				upper_val=`echo "$line" | tr a-z A-Z`
				
				if [ "$p_local_target_name" = "$upper_val" ]; then
					p_local_out_flg=1
					continue
				else
					p_local_list_of_entries=${p_local_list_of_entries}${line}"\n"
				fi
			fi	
		done

		# add
		if [ $p_local_out_flg -eq 1 ]; then
			IFS=$IFS_ORG
			local p_local_out="'"$p_local_list_of_entries"'"
			${P_printer_sudo_command}bash -c "echo -n -e $p_local_out > $file_name"
			IFS='
'
		fi
	done

	# restore delimiter.
	IFS=$IFS_ORG

	return 0	

}

#################################################################
#### Exec command for printer  $1:command to exec  $2:1..show execution command 
#################################################################
p_FUNC_show_and_exec_printer()
{
	if [ $2 -eq 1 ]; then
		printf "$L_INST_COM_01_01" "$1"
	fi
	
	$1 1> /dev/null		#show error message only
	return $?
}

#################################################################
#### Get "cups" command
#################################################################
p_FUNC_get_cupsd_command()
{
	local p_local_service_command_tmp=""
	local p_local_service_command=""
	local p_local_systemctl_command_tmp=""
	local p_local_systemctl_command=""

	#-----------------------------
	# Check "systemctl" command
	#-----------------------------
	p_local_systemctl_command_tmp=`whereis -b systemctl`
	p_local_systemctl_command=`echo -n ${p_local_systemctl_command_tmp} | cut -s -d' ' -f2`
	if [ -n "$p_local_systemctl_command" ]; then
		${p_local_systemctl_command} status cups.service 1> /dev/null
		if [ $? -eq 0 ]; then
			P_cupsd_command_current=${P_printer_sudo_command}${p_local_systemctl_command}" restart cups.service"
			return 0
		fi
	fi

	#-----------------------------
	# Check "service" command
	#-----------------------------
	p_local_service_command_tmp=`whereis -b service`
	p_local_service_command=`echo -n ${p_local_service_command_tmp} | cut -s -d' ' -f2`
	if [ -n "$p_local_service_command" ]; then
		${P_printer_sudo_command} ${p_local_service_command} cups status 1> /dev/null
		if [ $? -eq 0 ]; then
			P_cupsd_command_current=${P_printer_sudo_command}${p_local_service_command}" cups restart"
			return 0
		fi
	fi

	#-----------------------------
	# Check "/etc/init.d/cups"
	#-----------------------------
	if [ -f "$P_cupsd_command_1" ]; then
		P_cupsd_command_current=${P_printer_sudo_command}${P_cupsd_command_1}" restart"
		return 0
	fi
	
	#-----------------------------
	# Check "/etc/init.d/cupsys"
	#-----------------------------
	if [ -f "$P_cupsd_command_2" ]; then
		P_cupsd_command_current=${P_printer_sudo_command}${P_cupsd_command_2}" restart"
		return 0
	fi
	
	return 127	#error

}

#################################################################
#### Get "lpadmin" command
#################################################################
p_FUNC_get_lpadmin_command()
{
	#-----------------------------
	# Check "/usr/sbin/lpamin"
	#-----------------------------
	if [ -f "$P_lpadmin_command_full" ]; then
		P_lpadmin_command_current=${P_printer_sudo_command}$P_lpadmin_command_full
		return 0
	fi
	
	#-----------------------------
	# Get fullpath by "whereis" and check it.
	#-----------------------------
	lpadmin_path_tmp=`whereis -b lpadmin`
	lpadmin_path=`echo ${lpadmin_path_tmp} | cut -d' ' -f2`

	if [ -z "$lpadmin_path" ]; then
		lpadmin_path=`echo ${lpadmin_path_tmp} | cut -d\t -f2`
	fi
	
	if [ "$lpadmin_path" ]; then
		if [ -f "$lpadmin_path" ]; then
			P_lpadmin_command_current=${P_printer_sudo_command}$lpadmin_path
			return 0
		fi
	fi
	
	return 127	#error
	
}

#################################################################
#### Select "Yes" or "No". $1:message
#### (Loop until "yes" or "no" selected)
#################################################################
p_FUNC_check_yes_no()
{
	local p_local_result=-1	# neither "Yes" nor "No"

	while [ $p_local_result -eq -1 ]; do
		printf "$1" "[y]"
		read -r CMD

		#Change to uppercase
		CMD=`echo $CMD | tr a-z A-Z`

		case $CMD in
			"") p_local_result=1;;
			"Y") p_local_result=1;;
			"YES") p_local_result=1;;
			"N") p_local_result=0;;
			"NO") p_local_result=0;;
		esac

	done
	
	return $p_local_result
}

#################################################################
#### Make entry name to suggest(default value)  $1:base entry name (ex:"MP640")
#################################################################
p_FUNC_make_default_entryname()
{
	local p_local_count=0
	local p_local_entry_name=""
	local p_local_result=""

	p_local_entry_name=$1

	while [ -z "${p_local_result}" ]; do
		if [ $p_local_count -ge 1 ]; then
			p_local_entry_name=$1"-"$p_local_count
		fi
		p_FUNC_check_entry_exist $p_local_entry_name
		
		if [ $? -ne 0 ]; then
			p_local_result=""
		else
			p_local_result=$p_local_entry_name
		fi
		#
		p_local_count=`expr $p_local_count + 1`
		
	done
	
#	echo $p_local_result
	P_DEF_ENTRYNAME=$p_local_result
	
#	return 0
}

#################################################################
#### Check if the entry name exists or not.  $1:entry name to check
####   0:not exist  1:exist in cnij_entrys  2:exist in /etc/cups/ppd
#################################################################
p_FUNC_check_entry_exist()
{
	#-----------------------------
	# Check the return value of "cngpij --checkentryexist entryname" (new)
	#-----------------------------
#	local p_local_entry="'"$1"'"
#	cngpij --checkentryexist "$1" >& /dev/null
	lpstat -p "$1" 1>/dev/null 2>/dev/null
	
	if [ $? -eq 0 ]; then		#exist
		return 1
	fi

	return 0	# Same name is not found
}

#################################################################
#### Check if the entry name is valid.  $1:entry name to check
####   0:invalid  1:valid
#################################################################
p_FUNC_is_valid_entry_name()
{
	local p_local_tmpname=""
	
	p_local_tmpname="$1"

	case "$p_local_tmpname" in
		*[^a-zA-Z0-9\.\+\-\_\@]*)
			return 0;;	#NG
		*)
			return 1;;	#OK
	esac
	
}

#################################################################
#### 
#################################################################
p_FUNC_execute_prepare_process()
{
	local p_local_command=""

	p_local_command=`whereis -b ldconfig | cut -d' ' -f2`
	`${P_printer_sudo_command}${p_local_command}`;
}

#################################################################
#### Make printer list to show from backend output data. S1:USB or LAN string
#################################################################
p_FUNC_make_printer_list_from_backenddata()
{
	# initialize
	local p_local_current_model=""
	local p_local_cn_uri=""
	local p_local_srch_result=""
	local p_local_fax_term=""
	local p_local_dvice_uri=""
	local p_local_ip_add=""
	local p_local_current=""
	local p_local_current_upper=""
	local p_local_display_line=""
	local p_local_current_lowwer=""
	local p_local_is_std_usb_backend=0
	local p_local_is_target_printer=0
	P_target_model_list=""
	P_other_model_list=""
	P_target_model_num=0
	P_other_model_num=0
	P_is_std_usb_backend=0

	# P_DEF_ENTRYNAME:all uppercase..
	p_local_current_model=$P_DEF_ENTRYNAME
	
	# show message...
	printf "\n"
	printf "$L_INST_PRN_01_08"

	#-----------------------------
	# Restart cupsd. (just before device detection)
	#-----------------------------
#	$P_cupsd_command_current restart 1> /dev/null		#show error message only
	$P_cupsd_command_current 1> /dev/null		#show error message only
	if [ $? -ne 0 ]; then
		printf "$L_INST_PRN_01_27"
		exit		#quit immediately
	fi

	#-----------------------------
	# Execute device search
	#-----------------------------
	if [ "$1" = "LAN" ]; then
		p_local_srch_result=`${P_printer_sudo_command}cnijlgmon3 --installer_net`
	else
		p_local_srch_result=`${P_printer_sudo_command}cnijlgmon3 --installer_usb`
	fi

	#-----------------------------
	# Make printer list array with detected printers
	#-----------------------------
	# set delimiter
	IFS='
	'
	for line in ${p_local_srch_result}; do
		#line=`echo -n ${line}`
		#line=${line//\"/\\\"}
	
		# Extract the 3rd field("Canon MX320 series") and set to value.
		#value=`perl -e '"'$line'" =~ /\"(Canon.+?)\"/;print $1'`
		if [ $p_local_is_target_printer -eq 1 ]; then
			p_local_is_target_printer=`expr $p_local_is_target_printer - 1`
		fi

		value=`expr $line : '.*"\(Canon[^"]*series[^"]*\)"'`
		
		# Skip FAX device
		p_local_fax_term=""
		if [ "$value" ]; then
			p_local_fax_term=`expr $value : '.*\(FAX\).*$'`
		fi
		if [ "$p_local_fax_term" ]; then
			continue
		fi
		
		# Extract the 2nd field(/00-1E-8F-0E-1D-44) and set to dvice_uri.
		p_local_cn_uri=`echo ${line} | cut -d' ' -f2`
		p_local_dvice_uri=`echo ${p_local_cn_uri} | cut -d':' -f2`

		# If the I/F is LAN, delete "/" and add IPP address.
		if [ "$1" = "LAN" ]; then
			#p_local_dvice_uri=`echo ${p_local_dvice_uri} | cut -d'/' -f2`
			p_local_dvice_uri=`expr ${p_local_dvice_uri} : '.*serial=\(.\+\)'`
			
			#p_local_ip_add=`perl -e '"'$line'" =~ /\"(IP.+)\"/;print $1'`
			p_local_ip_add=`expr $line : '.*"\(IP[^"]*\).*$'`
			#p_local_ip_add=`echo $p_local_ip_add | sed -e "s/^IP://" `	#new
			p_local_ip_add=`expr $p_local_ip_add : 'IP:\(.\+\)'`
			
			p_local_dvice_uri=$p_local_dvice_uri" "$p_local_ip_add
			
		fi

		if [ "${value}" != "" ]; then
			p_local_current=`echo ${value} | cut -d' ' -f2`
			p_local_current_upper=`echo $p_local_current | tr a-z A-Z`

			# fix backend
			P_is_std_usb_backend=${p_local_is_std_usb_backend}

			for printer in ${P_support_printer[@]}; do
				if [ "${p_local_current_upper}" = "${printer}" ]; then	# If target model..
					
					P_target_model_num=`expr $P_target_model_num + 1`	# array number starts with "1".
					p_local_display_line="${P_target_model_num}) ${value} (${p_local_dvice_uri})"
					P_target_model_list[P_target_model_num]=$p_local_display_line
					p_local_is_target_printer=`expr $p_local_is_target_printer + 1`
					break
				fi 
			done

			if [ $p_local_is_target_printer -ne 1 ]; then
				# Need check PPD folder
				# If other model...
				
				p_local_current_lowwer=`echo $p_local_current_upper | tr A-Z a-z`
				ppdname="canon${p_local_current_lowwer}"
				
				for filepath in ${C_ppdfile_path}
				do
					ppd_device_name=`basename $filepath .ppd`

					if [ $ppdname = $ppd_device_name ]; then
						#check is support PWGRaster			
						grep -q $raster_command $filepath
						if [ $? -eq 0 ]; then
							P_other_model_num=`expr ${P_other_model_num} + 1`		# arrya number starts with "101".
							p_local_display_line="`expr $P_other_model_num + 100`) ${value} (${p_local_dvice_uri})"
							P_other_model_list[P_other_model_num]=$p_local_display_line
						fi
					fi
				done
			fi
		fi
	done
	
	# restore delimiter
	IFS=$IFS_ORG
	
#	echo "P_target_model_num=$P_target_model_num"
#	echo "P_other_model_num=$P_other_model_num"
	
}

#################################################################
#### Select device from printer lists menu. S1:backend name
#################################################################
p_FUNC_select_printer_from_list()
{
	
	P_ans=''
	local p_local_defaultnum
	local p_local_target_list_title
	local p_local_other_list_title
	local p_local_current_num
	local p_local_indata
	local p_local_indata_for_array

	#-----------------------------
	# Set default selection.
	#-----------------------------
	if [ $P_target_model_num -eq 0 ]; then
		p_local_defaultnum=0
	else
		p_local_defaultnum=1
	fi
	
	# Set list titles according to backend name.
	if [ "$1" != "LAN" ]; then
		p_local_target_list_title="$L_INST_PRN_01_14"
		p_local_other_list_title="$L_INST_PRN_01_15"
	else
		p_local_target_list_title="$L_INST_PRN_01_12"
		p_local_other_list_title="$L_INST_PRN_01_13"
	fi

	#-----------------------------
	# Show printer list
	#-----------------------------
	printf "\n"
	printf "\n"
	printf "#=========================================================#\n"
	printf "#  $L_INST_PRN_01_09"
	printf "#=========================================================#\n"
	printf "$L_INST_PRN_01_10"
	printf -- "-----------------------------------------------------------\n"
	printf " 0) $L_INST_PRN_01_11\n"
	printf -- "-----------------------------------------------------------\n"
    
    if [ $P_target_model_num -gt 0 ]; then
    	printf "$p_local_target_list_title"
#		for current in ${P_target_model_list[@]}; do
#		echo $current
#		done
		for (( i=0; i<$P_target_model_num; i++ ))
		{
			p_local_current_num=`expr $i + 1`
			echo ${P_target_model_list[p_local_current_num]}
		}
	else
    	printf "$L_INST_PRN_01_18"
	fi

	echo "-----------------------------------------------------------"

    if [ $P_other_model_num -gt 0 ]; then
	   	printf "$p_local_other_list_title"
	#	for current in ${P_other_model_list[@]}; do
	#		echo $current
	#	done
		for (( i=0; i<$P_other_model_num; i++ ))
		{
			p_local_current_num=`expr $i + 1`
			echo ${P_other_model_list[p_local_current_num]}
		}
		echo "-----------------------------------------------------------"
	fi

	#-----------------------------
	# Show default choice
	#-----------------------------
	if [ $p_local_defaultnum -eq 0 ]; then
		printf "$L_INST_PRN_01_16" "[0]" "$L_INST_PRN_01_11" > /dev/stderr
	
	else
		tmp_selected=${P_target_model_list[${p_local_defaultnum}]}
		tmp_selected=`echo $tmp_selected | cut -d " " -f 2-`
		printf "$L_INST_PRN_01_16" "[1]" "$tmp_selected" > /dev/stderr
	fi
	

	#-----------------------------
	# Loop until valid selection is done...
	#-----------------------------

	# set delimiter
	IFS='
'
	while [ -z "${P_ans}" ]; do
		
		# Please select...
		printf "$L_INST_PRN_01_17 [${p_local_defaultnum}]" > /dev/stderr
		IFS=$IFS_ORG
		read -r p_local_indata
		IFS='
'

		# Enter(not select number) -> deault value selected
		if [ "${p_local_indata}" = "" ] ; then
			p_local_indata=${p_local_defaultnum}
		fi
		
		# Check the inputted data.
		#to Upper case
		p_local_indata=`echo $p_local_indata | tr a-z A-Z`
		
		case "$p_local_indata" in

			# "0"(re-search) -> return 0 immediately
			"0")
				# restore delimiter and return.
				IFS=$IFS_ORG
				return 1;;

			# "Q"(quit) -> return 2 immediately
			"Q")
				# restore delimiter and return.
				IFS=$IFS_ORG
				return 2;;

			*[^0-9]*)
				# contain characters other than number(0-9).-> invaild -> back to input step.
				P_ans='';;
				
			*)
				# valid -> go to next step.
				# Verify inputted value
				# Check if the choice is target model or not.
				
				if [ "${p_local_indata}" -ge 1 -a "${p_local_indata}" -le 100 ] 2> /dev/null; then	#1-100: target model
					if [ "${p_local_indata}" -ge 1 -a "${p_local_indata}" -le "${P_target_model_num}" ] 2> /dev/null; then
						P_ans=${P_target_model_list[${p_local_indata}]}
					else
						:
					fi
				else																#101-: other model
					p_local_indata_for_array=`expr $p_local_indata - 100`
					if [ "${p_local_indata_for_array}" -ge 1 -a "${p_local_indata_for_array}" -le "${P_other_model_num}" ] 2> /dev/null; then
						P_ans=${P_other_model_list[${p_local_indata_for_array}]}
					else
						:
					fi
				fi
		esac
	done
	
	#echo "select num is ${P_ans}"
	
	# restore delimiter and return.
	IFS=$IFS_ORG
	return 0

}

#################################################################
#### Make DeviceURI  $1:USB or LAN string, $2:printer list line
#################################################################
p_FUNC_make_uri()
{
	# set delimiter
	IFS='
	'
#	echo "choice=$2"
	local p_local_uri=""
	
	# Extract "00-00-85-CE-9B-17 172.21.81.49"or"/dev/usb/lp0"
	#p_local_uri=`perl -e '"'$2'" =~ /\((.+)\)/;print $1'`
	p_local_uri=`expr $2 : '.*(\(.\+\)).*$'`
	
	# If I/F is LAN: "00-00-85-CE-9B-17 172.21.81.49" -> "00-00-85-CE-9B-17" -> "/00-00-85-CE-9B-17"
	if [ "$1" = "LAN" ]; then	#LAN
		p_local_uri=`echo $p_local_uri | cut -d' ' -f1`
		p_local_uri="//Canon/?port=net&serial="$p_local_uri
	fi

	P_current_uri=$p_local_uri
#	echo P_current_uri="$P_current_uri"
	# restore delimiter
	IFS=$IFS_ORG
	
}

#################################################################
#### Entry creation main  $1:complete message  $2:device("mp640series")  $3:system("rpm")
#################################################################
P_FUNC_MAIN_make_queue()
{
	IFS_ORG=$IFS

	#echo ""
	#echo "## Driver packages installed. ##"
	
	P_printer_device=" "
	
	# make P_printer_sudo_command
	if [ "$2" = "rpm" ]; then
		P_printer_sudo_command=""
		P_entry_list_path=${P_entry_list_path_rpm}${P_entry_list_dir}
		P_all_entry_list_path=${P_entry_list_path_rpm}${P_all_entry_list_dir}
	else
		P_printer_sudo_command="sudo "
		P_entry_list_path=${P_entry_list_path_deb}${P_entry_list_dir}
		P_all_entry_list_path=${P_entry_list_path_deb}${P_all_entry_list_dir}
	fi

	####################################
	### Make entry_list file (blank file).
	####################################
	if [ ! -d $P_entry_list_path ]; then
		${P_printer_sudo_command}mkdir -p $P_entry_list_path 2> /dev/null
	fi
	P_entry_list_fullname=$P_entry_list_path${P_entry_list_name}
	${P_printer_sudo_command}touch $P_entry_list_fullname

	####################################
	### prepare command.
	####################################
	p_FUNC_get_cupsd_command
	if [ $? -ne 0 ]; then
		printf "$L_INST_PRN_01_27"
		exit		#quit immediately
	fi
#	echo "cups=$P_cupsd_command_current"
	
	p_FUNC_get_lpadmin_command
	if [ $? -ne 0 ]; then
		printf "$L_INST_PRN_01_27"
		exit		#quit immediately
	fi
#	echo "lpadmin=$P_lpadmin_command_current"

	p_FUNC_execute_prepare_process
	
	####################################
	### Registration start
	####################################
	printf "\n"
	printf "#=========================================================#\n"
	printf "#  $L_INST_PRN_01_01"
	printf "#=========================================================#\n"
	printf "$L_INST_PRN_01_02"
	printf "$L_INST_PRN_01_03"
	echo -n "> "
	read CMD
	
	####################################
	### Restart cupsd. -> moved to "p_FUNC_make_printer_list_from_backenddata" (just before device detection)
	####################################

	####################################
	### Check if LAN I/F is supported.
	####################################
	local p_local_SUPPORT_LAN=1

	####################################
	### Select I/F. (If LAN is not supported, skip this step.)
	####################################
	local p_local_BACKENDNAME=""
	local p_local_I_F=""
	if [ "${p_local_SUPPORT_LAN}" -eq 1 ]; then
		printf "\n"
		printf "#=========================================================#\n"
	    printf "#  $L_INST_PRN_01_04"
		printf "#=========================================================#\n"
		printf " 1) $L_INST_PRN_01_05"
		printf " 2) $L_INST_PRN_01_06"

		while [ -z "$p_local_I_F" ]; do
			printf "$L_INST_PRN_01_07" "[1]"
			read -r CMD
		
			case $CMD in
				"")	#USB
					p_local_BACKENDNAME="cnijbe2"
					p_local_I_F="USB";;
				"1")	#USB
					p_local_BACKENDNAME="cnijbe2"
					p_local_I_F="USB";;
				"2")	#Network
					p_local_BACKENDNAME="cnijbe2"
					p_local_I_F="LAN";;
			esac
		done
		
	else
		#Skip I/F select step
		p_local_BACKENDNAME="cnijbe2"
		p_local_I_F="USB_NOTSELECT"
	fi
	

	####################################
	### Search printer devices and show list.
	####################################
	retvalue=1
	until [ $retvalue -eq 0 ]
	do
		#Search printers.
		#ver400 p_FUNC_make_printer_list_from_backenddata $p_local_BACKENDNAME
		p_FUNC_make_printer_list_from_backenddata $p_local_I_F

		#Show printer list.
		#ver400 p_FUNC_select_printer_from_list $p_local_BACKENDNAME
		p_FUNC_select_printer_from_list $p_local_I_F

		retvalue=$?
		if [ $retvalue -eq 0 ]; then		#some device selected -> re-search
			:
		elif [ $retvalue -eq 1 ]; then		#"0" selected -> re-search
			echo ""
			printf "$L_INST_PRN_01_03"
			echo -n "> "
			read CMD		#wait enter...
		elif [ $retvalue -eq 2 ]; then		#"Q" selected -> exit immediately
			printf "$L_INST_PRN_01_27"
			exit		#quit immediately
		fi
	done

#	echo "P_ans=$P_ans"

	### P_DEF_ENTRYNAME..."MX860"
	#Cut "series" from device
	local p_local_SHOTMODELNAME=""
	p_local_SHOTMODELNAME=`echo $P_ans | cut -d' ' -f3` 
	#p_local_SHOTMODELNAME=`echo $P_printer_device | sed -e "s/series$//"`
	#p_local_SHOTMODELNAME=`expr $P_printer_device : '\(.\+\)series$'`
	#Change to uppercase
	P_DEF_ENTRYNAME=`echo $p_local_SHOTMODELNAME | tr a-z A-Z`

	# make URI
	P_current_uri=""
	p_FUNC_make_uri "$p_local_I_F" "$P_ans"

	####################################
	### Input entry name
	####################################
	### Make default name
	# P_DEF_ENTRYNAME + I/F
	if [ "$p_local_I_F" = "USB_NOTSELECT" ]; then
		P_DEF_ENTRYNAME=$P_DEF_ENTRYNAME
	else
		P_DEF_ENTRYNAME=$P_DEF_ENTRYNAME$p_local_I_F
	fi
	
	# Make default(pre-set) entry name.
	p_FUNC_make_default_entryname $P_DEF_ENTRYNAME
	
	local p_local_ENTRYNAME=""
	local p_local_remake_flag=0
	
	printf "\n"
	printf "#=========================================================#\n"
	printf "#  $L_INST_PRN_01_19"
	printf "#=========================================================#\n"

	while [ -z "$p_local_ENTRYNAME" ]; do
		p_local_ENTRYNAME=""
		printf "$L_INST_PRN_01_20[$P_DEF_ENTRYNAME]"
		read -r p_local_ENTRYNAME
		
		case "$p_local_ENTRYNAME" in
			"")		# use default name
				p_local_ENTRYNAME=$P_DEF_ENTRYNAME;;
		esac
		
		# Check if specified name is valid.
		p_FUNC_is_valid_entry_name "$p_local_ENTRYNAME"

		if [ $? -eq 0 ]; then		# invalid printer name
			printf "$L_INST_PRN_01_22"
			p_local_ENTRYNAME=""
			echo ""	
			continue
		fi
		
		
		# Check if the specified name is already exist.
		p_FUNC_check_entry_exist $p_local_ENTRYNAME
		
		if [ $? -ne 0 ]; then
			#If the entry_name exists, ask if overwrite or not.
			p_FUNC_check_yes_no "$L_INST_PRN_01_21"
			
			if [ $? -eq 0 ]; then		#No -> back to input step
				p_local_ENTRYNAME=""
				echo ""	
			else						#Yes-> set "p_local_remake_flag" 1
				p_local_remake_flag=1
			fi
		else
			:
		fi
		
	done
	
	local p_local_modelname_lower=`echo $p_local_SHOTMODELNAME | tr A-Z a-z`
	local p_local_PPDNAME=canon$p_local_modelname_lower.ppd
	
	####################################
	### Excute lpadmin (registration)
	####################################
	if [ $p_local_remake_flag -eq 1 ]; then
		# remove existing entry.
		p_FUNC_show_and_exec_printer "$P_lpadmin_command_current -x ${p_local_ENTRYNAME}" 0
		if [ $? -ne 0 ]; then
			printf "$L_INST_PRN_01_27"
			exit		#quit immediately
		fi
		# delete entry from file
		p_FUNC_delete_entryname_from_file "$p_local_ENTRYNAME"
	fi
	
	if [ $P_is_std_usb_backend -ne 0 ]; then
		p_local_BACKENDNAME="usb"
	fi
	p_FUNC_show_and_exec_printer "$P_lpadmin_command_current -p $p_local_ENTRYNAME -P ${P_ppd_install_path}$p_local_PPDNAME -v $p_local_BACKENDNAME:$P_current_uri -E" 1
	if [ $? -ne 0 ]; then
		printf "$L_INST_PRN_01_27"
		exit		#quit immediately
	fi

	####################################
	### Add the entry name to the "entry_list" file.(not to add if the entry is overwrited)
	####################################
	p_FUNC_write_entrydata_to_file "$P_entry_list_fullname" $p_local_ENTRYNAME
	

	####################################
	### Set the registered entry as default printer.
	####################################
	printf "\n"
	printf "#=========================================================#\n"
    printf "#  $L_INST_PRN_01_23"
	printf "#=========================================================#\n"
	
	p_FUNC_check_yes_no "$L_INST_PRN_01_24"
	
	if [ $? -eq 1 ]; then
		p_FUNC_show_and_exec_printer "$P_lpadmin_command_current -d $p_local_ENTRYNAME" 0
		if [ $? -ne 0 ]; then
			printf "$L_INST_PRN_01_27"
			exit		#quit immediately
		fi
		
	fi

	####################################
	### Restart cupsd.
	####################################
#	$P_cupsd_command_current restart 1> /dev/null		#show error message only
	$P_cupsd_command_current 1> /dev/null		#show error message only
	if [ $? -ne 0 ]; then
		printf "$L_INST_PRN_01_27"
		exit		#quit immediately
	fi

	####################################
	### Finish (Show registration information)
	####################################
	printf "\n"
	printf "#=========================================================#\n"
    printf "$1"
    printf "$L_INST_PRN_01_25" "$p_local_ENTRYNAME"
    printf "$L_INST_PRN_01_26"
	printf "#=========================================================#\n"
	printf ""

	return 0
	
}

#################################################################
#### Delete entry main   $1:device("mp640series")  $2:system("rpm")
#################################################################
P_FUNC_MAIN_delete_all_queue()
{
	printf "#=========================================================#\n"
    printf "#  $L_INST_PRN_02_01"
	printf "#=========================================================#\n"
	printf "$L_INST_PRN_02_02"

	IFS_ORG=$IFS

	if [ "$1" = "rpm" ]; then
		P_entry_list_path=${P_entry_list_path_rpm}${P_entry_list_dir}
	else
		P_entry_list_path=${P_entry_list_path_deb}${P_entry_list_dir}
	fi
	
	p_FUNC_check_yes_no "$L_INST_PRN_02_03"
	if [ $? -eq 0 ]; then		#No
		exit		#quit immediately (say nothing)
	
	else						#Yes
	
		# initialize
		local p_local_existentrys=""
		local p_local_entrys_to_delete
		local p_local_entrys_to_delete_num=0
		
		#-----------------------------
		# Prepare file names and Get entry list file.
		#-----------------------------
#		echo P_printer_device=$P_printer_device
		
		P_entry_list_fullname=$P_entry_list_path${P_entry_list_name}
#		echo P_entry_list_fullname=$P_entry_list_fullname
		if [ -f "$P_entry_list_fullname" ]; then
			# set delimiter
			IFS='
			'
			p_local_existentrys=`cat $P_entry_list_fullname`
		else
			# entry list file not found -> go to package uninstallation
			printf "$L_INST_PRN_02_05"
			# restore delimiter and return.
			IFS=$IFS_ORG
			return 1		#skip and go to remove package
		fi
		
		# make P_printer_sudo_command
		if [ "$2" = "rpm" ]; then
			P_printer_sudo_command=""
		else
			P_printer_sudo_command="sudo "
		fi
		

		#-----------------------------
		# prepare for command...
		#-----------------------------
		p_FUNC_get_lpadmin_command
		if [ $? -ne 0 ]; then
			#-----------------------------
			# Failed to get lpadmin command -> Remove entry_list file and go to package uninstallation
			#-----------------------------
			printf "$L_INST_PRN_02_05"
			${P_printer_sudo_command}rm -f $P_entry_list_fullname
			${P_printer_sudo_command}rmdir -p --ignore-fail-on-non-empty $P_entry_list_path

			# restore delimiter and return.
			IFS=$IFS_ORG
			return 1		#skip and go to remove package
		fi
#		echo "lpadmin=$P_lpadmin_command_current"

		
		#-----------------------------
		# make array of entrys to delete.
		#-----------------------------
		for line in ${p_local_existentrys}; do
			if [ -n "$line" ]; then			# skip blank line
				p_local_entrys_to_delete[p_local_entrys_to_delete_num]=$line
				p_local_entrys_to_delete_num=`expr $p_local_entrys_to_delete_num + 1`
			fi
		done
		
		# restore delimiter
		IFS=$IFS_ORG
		
		
		#-----------------------------
		# delete entry for each line.
		#-----------------------------
		for (( i=0; i<$p_local_entrys_to_delete_num; i++ ))
		{
			if [ -n "${p_local_entrys_to_delete[i]}" ]; then	# skip blank line
				p_FUNC_show_and_exec_printer "$P_lpadmin_command_current -x ${p_local_entrys_to_delete[i]}" 1
				if [ $? -ne 0 ]; then
					printf "$L_INST_PRN_02_04" ${p_local_entrys_to_delete[i]}
				fi
			fi
		}
		
#		for line in ${p_local_existentrys}; do
#			if [ -n "$line" ]; then	# skip blank line
#				p_FUNC_show_and_exec_printer "$P_lpadmin_command_current -x $line" 1
#				if [ $? -ne 0 ]; then
#					echo "$L_INST_PRN_02_04" ${line}
#					echo "$L_INST_02_03_2"
#				fi
#			fi
#		done
		
		#-----------------------------
		# Remove entry_list file.
		#-----------------------------
		${P_printer_sudo_command}rm -f $P_entry_list_fullname
		${P_printer_sudo_command}rmdir -p --ignore-fail-on-non-empty $P_entry_list_path
		
	fi
	
	return 0
	
}

#== test program ====================================
# 
#L_INST_01_24="Installation has been completed."
#L_INST_02_04="Uninstallation has been completed."
#argment=$1
#if [ "$argment" = "--uninstall" ]; then
#	test_model=$2		#"mp640series"
#	$C_function02 $test_model  "rpm"
#	echo "$L_INST_02_04"
#else
#	$C_function03 "3.20"
#	$C_function01 "$L_INST_01_24" "mp640series" "rpm"
#fi
#====================================================


C_ERR_CODE="128"
C_big="50"
C_equal="40"
C_small="30"

C_common="common"
C_system=""
C_arch=""
C_arch32=""
C_arch64=""

C_err="no_error"
C_err_unknown="err_unknown"
C_err_mismatch="err_mismatch"
C_err_usage="err_usage"

C_install_script_fname="install.sh"
C_config_path_rpm="/usr/local/bin"
C_config_path_deb="/usr/bin"

C_copyrightb="=================================================="

C_arg_inst="[ --bit32 | --bit64 ]"
C_arg_pkg="[ --uninstall | --version ]"

C_FUNC_show_and_exec()
{
	printf "$L_INST_COM_01_01" "$1"
	$1
}

C_FUNC_version_comp()
{
	local c_tmpstr=""
	local c_ver1=""
	local c_ver2=""
	local c_rela1=""
	local c_reln1=""
	local c_rela2=""
	local c_reln2=""
	
	C_FUNC_makelist()
	{
		echo $1
		echo $2
	}

	## version compare ##
	# ex. 3.10->310, 1.30->130 #
	c_tmpstr=`echo ${1%%-*}`
	c_ver1=`echo ${c_tmpstr%%.*}``echo ${c_tmpstr##*.}`
	c_tmpstr=`echo ${2%%-*}`
	c_ver2=`echo ${c_tmpstr%%.*}``echo ${c_tmpstr##*.}`

	# ex. 310 > 300  #
	if [ "$c_ver1" -gt "$c_ver2" ]; then
		return $C_big
	elif [ "$c_ver1" -lt "$c_ver2" ]; then
		return $C_small
	fi
	
	## release compare ##
	# ex. a13->[a][13], 2->[][2] #
	c_tmpstr=`echo ${1##*-}`
	c_rela1=`echo ${c_tmpstr%%[0-9]*}`
	c_reln1=`echo ${c_tmpstr##*[a-z]}`
	c_tmpstr=`echo ${2##*-}`
	c_rela2=`echo ${c_tmpstr%%[0-9]*}`
	c_reln2=`echo ${c_tmpstr##*[a-z]}`

	# ex. [a][13] < [][2] #
	if [ -z "$c_rela1" ] && [ -n "$c_rela2" ]; then
		return $C_big
	elif [ -n "$c_rela1" ] && [ -z "$c_rela2" ]; then
		return $C_small
	fi
	
	# ex. [a][2] < [b][1] #
	if [ -n "$c_rela1" ] && [ "$c_rela1" != "$c_rela2" ]; then
		list=`C_FUNC_makelist $c_rela1 $c_rela2 | sort`
		for c_tmpstr in $list; do
			if [ "$c_tmpstr" = "$c_rela1" ]; then
				return $C_small
			else
				return $C_big
			fi
		done
	fi
	
	# ex. [a][2] > [a][1], [b][9] < [b][10] #
	if [ "$c_reln1" -gt "$c_reln2" ]; then
		return $C_big
	elif [ "$c_reln1" -lt "$c_reln2" ];then
		return $C_small
	else
		return $C_equal
	fi
}

C_FUNC_get_system()
{
	local c_system_rpm=""
	local c_system_deb=""

	## Judge is the distribution supporting rpm? ##
	rpm --version 1> /dev/null 2>&1
	c_system_rpm=$?

	## Judge is the distribution supporting dpkg(debian)? ##
	dpkg --version 1> /dev/null 2>&1
	c_system_deb=$?

	## rpm error and deb error is error ##
	if [ $c_system_rpm != 0 -a $c_system_deb != 0 ]; then
		return $C_ERR_CODE
	elif [ $c_system_rpm = 0 -a $c_system_deb = 0 ]; then
		C_system=$C_default_system
	else
		if test $c_system_rpm -eq 0; then
			C_system="rpm"
		else
			C_system="deb"
		fi
	fi

	if [ $C_system = "rpm" ]; then
		C_arch32="i386"
		C_arch64="x86_64"
	else
		C_arch32="i386"
		C_arch64="amd64"
	fi
	
	return 0
}

C_FUNC_get_bitconf()
{
	local c_bit_conf=""
	local c_sudo_command=""
	local c_arg1=$1

	if [ $C_system = "deb" ]; then
		c_sudo_command="sudo "
	fi

	getconf LONG_BIT 1> /dev/null 2>&1
	if [ $? -eq 0 ]; then
		c_bit_conf=`getconf LONG_BIT`
	else
		c_bit_conf=""
	fi

	if [ -z $C_arch ]; then
		# No argment and getconf=32|64 -> continue #
		if [ -z $c_bit_conf ]; then
			if [ -z $c_arg1 ]; then
				C_err=$C_err_unknown
			elif [ $c_arg1 = "version" ]; then
				C_arch="*"
			fi
		elif [ $c_bit_conf = "32" ]; then
			C_arch=$C_arch32
		elif [ $c_bit_conf = "64" ]; then
			C_arch=$C_arch64
		else
			C_err=$C_err_unknown
		fi
	else
		if [ $C_arch = "32" ]; then
			# --bit32 and getconf=error -> continue #
			if [ -z $c_bit_conf ]; then
				C_arch=$C_arch32
			elif [ $c_bit_conf = "32" ]; then
				C_arch=$C_arch32
			else
				C_err=$C_err_mismatch
			fi
		elif [ $C_arch = "64" ]; then
			# --bit64 and getconf=error -> continue #
			if [ -z $c_bit_conf ]; then
				C_arch=$C_arch64
			elif [ $c_bit_conf = "64" ]; then
				C_arch=$C_arch64
			else
				C_err=$C_err_mismatch
			fi
		fi
	fi

	if [ $C_err = $C_err_mismatch ]; then
		printf "$L_INST_COM_01_06"
		printf "\n  ${c_sudo_command}${0}\n\n"
		return $C_ERR_CODE
	elif [ $C_err = $C_err_unknown ]; then
		printf "$L_INST_COM_01_05"
		printf "\n  ${c_sudo_command}${0} ${C_arg_inst}\n\n"
		return $C_ERR_CODE
	fi	
	
	return 0
}

C_FUNC_localize()
{
	local lc_file_dir=$1

	## Get current LANG information ##
	local current_lang=`echo $LANG | tr '[:upper:]' '[:lower:]'`

	## Get printer or scanner ##
	local driver=""
	if [ $C_main_module = "cnijfilter2" ]; then
		driver="printer"
	else
		driver="scanner"
	fi

	## Get localize file name ##
	local lc_file="nolocalize"
	case "${current_lang##*.}" in
		utf8 | utf-8)
			case "${current_lang%%.*}" in
				ja_jp)
					lc_file="${driver}_ja_utf8.lc"
					;;
				fr_fr)
					lc_file="${driver}_fr_utf8.lc"
					;;
				zh_cn)
					lc_file="${driver}_zh_utf8.lc"
					;;
			esac
			;;
	esac

	## Set localize file ##
	if [ $lc_file != "nolocalize" ]; then
		if [ -f ${lc_file_dir}/${lc_file} ]; then
			source ${lc_file_dir}/${lc_file}
		fi
	fi
	
	return 0
}

######################################################
#### _ _ E x e c u t e _ I n s t a l l . s h  _ _ ####
######################################################
if [ ${0##*/} = $C_install_script_fname ]; then

	#################################################################
	#### _ _ B o t h _ P a c k a g e _ C o m m o n _ F l o w _ _ ####
	#################################################################

	C_argment=$1

    ################
	### Localize ###
    ################
    C_local_path_inst="`echo $(dirname $0)`/resources"
	C_FUNC_localize "$C_local_path_inst"

	########################
	## Show the copyright ##
	########################
	C_FUNC_get_system
	if [ $? -eq 0 ]; then
		if [ $C_system = "rpm" ]; then
			##  Check permission by root ##
			if test `id -un` != "root"; then
				su -c "$0 $*"
				exit
			fi
		else
			sudo echo > /dev/null
			if [ $? -ne 0 ]; then
				exit
			fi
		fi
	fi
	echo $C_copyrightb; echo
	$C_function03 "${C_version%%-*}"
	echo ; echo $C_copyrightb

	#########################
	### Check the argment ###
	#########################
	if [ $# -eq 1 ]; then
		if  [ $C_argment = "--bit32" ]; then
			C_arch="32"
		elif [ $C_argment = "--bit64" ]; then
			C_arch="64"
		else
			C_err=$C_err_usage
		fi
	elif [ $# -ne 0 ]; then
		C_err=$C_err_usage
	fi

	if [ $C_err = $C_err_usage ]; then
		printf "$L_INST_COM_02_01" "${0##*/} $C_arg_inst"
		exit
	fi

    #################################
	### Judge distribution system ###
    #################################

	C_FUNC_get_system
	if [ $? -ne 0 ]; then
		printf "$L_INST_COM_01_02"
		exit
	fi

    #########################
	### Judge 32bit/64bit ###
    #########################

	C_FUNC_get_bitconf
	if [ $? -ne 0 ]; then
		exit
	fi

    ############################
	### Check file structure ###
    ############################

	## Get full path of script and packages ##
	C_pkg_path=`echo $(dirname $0)`/packages
	if [ ! -d $C_pkg_path ]; then
		printf "$L_INST_COM_01_03"
		exit
	fi

	## Count total files and check the filename ##
	C_file_cnt=0
	C_files=$C_pkg_path/*${C_arch}*
	for filename in $C_files; do
		if [ $filename != $C_pkg_path ]; then
			# Count number of C_files           #
			C_file_cnt=`expr $C_file_cnt + 1`
		fi
	done

	## Check number of C_files ##
	if [ $C_file_cnt -ne 1 ]; then
		printf "$L_INST_COM_01_03"
		exit
	fi

	## Recheck package names ##
	C_pkgname_common=$C_main_module

	if [ $C_system = "rpm" ]; then
		C_fpath_common=$C_pkg_path/$C_pkgname_common-$C_version.$C_arch.$C_system

	else
		C_fpath_common=$C_pkg_path/${C_pkgname_common}_${C_version}_$C_arch.$C_system

	fi

	## Check having common and depend package files ##
	if [ ! -f $C_fpath_common ]; then
		printf "$L_INST_COM_01_03"
		exit
	fi

	#####################################################################
	#### _ _ P a c k a g e _ S y s t e m _ D e p e n d _ F l o w _ _ ####
	#####################################################################

	C_FUNC_rpm_install_process()
	{
		local c_fpath_pkg_name=$1
		local c_pkg_name=$2
		local c_exec_update=1
		local c_installed_pkg=""
		
		## result -> 0:Package installed, 1:Package not installed ##
		c_installed_pkg=`rpm -q $c_pkg_name`
		if [ $? -eq 0 ]; then
			c_installed_pkg_ver=`echo ${c_installed_pkg##$c_pkg_name-}`
			c_installed_pkg_ver=`echo ${c_installed_pkg_ver%%.$C_arch32}`
			c_installed_pkg_ver=`echo ${c_installed_pkg_ver%%.$C_arch64}`
			C_FUNC_version_comp $c_installed_pkg_ver $C_version
			if [ $? -ne $C_small ]; then
				c_exec_update=0
			fi
		fi

		if [ $c_exec_update -eq 1 ]; then
			C_FUNC_show_and_exec "rpm -Uvh $c_fpath_pkg_name"
			if [ $? -ne 0 ]; then
				return $C_ERR_CODE
			fi
		else
			C_FUNC_show_and_exec "rpm --test -U $c_fpath_pkg_name"
		fi

		return 0	
	}

	C_FUNC_deb_install_process()
	{
		local c_fpath_pkg_name=$1

		## result -> 0:Install process complete, 1:Install process depend error ##
		C_FUNC_show_and_exec "sudo dpkg -iG $c_fpath_pkg_name"
		if [ $? != 0 ]; then
			return $C_ERR_CODE
		fi
		
		return 0
	}

	## Make Package-config script, after Check Newer version config script is installed already ##
	C_FUNC_make_pkgconfig()
	{
		local c_pkgconfig_fname=$1
		local c_script_path=$2
		local c_sudo_command=$3
		local c_pkgconfig_fpath="$c_script_path/$c_pkgconfig_fname"
		local c_config_path=""

		if [ ! -d /usr ]; then
			$c_sudo_command mkdir /usr
		fi
		if [ $2 = "rpm" ]; then
			if [ ! -d /usr/local ]; then
				mkdir /usr/local
			fi
			c_config_path=$C_config_path_rpm
		else
			c_config_path=$C_config_path_deb
		fi
		if [ ! -d $c_config_path ]; then
			$c_sudo_command mkdir $c_config_path
		fi

		$c_sudo_command cp -af $(dirname $0)/$C_install_script_fname $c_pkgconfig_fpath

		## Change file permission to same install.sh ##
		$c_sudo_command chmod 755 $c_pkgconfig_fpath
		$c_sudo_command chown root $c_pkgconfig_fpath
		$c_sudo_command chgrp root $c_pkgconfig_fpath
	}

	## Copy Localize-file, after making pkeconfig script ##
	C_FUNC_copy_lcfile()
	{
		local c_lcfile_srcpath=$1
		local c_lcfile_dstname=$2
		local c_sudo_command=$3
		local c_lcfile_dstpath=""

		if [ ! -d /usr ]; then
			$c_sudo_command mkdir /usr
		fi
		if [ $C_system = "rpm" ]; then
			if [ ! -d /usr/local ]; then
				mkdir /usr/local
			fi
			if [ ! -d /usr/local/share ]; then
				mkdir /usr/local/share
			fi
			c_lcfile_dstpath="/usr/local/share"
		else
			if [ ! -d /usr/share ]; then
				$c_sudo_command mkdir /usr/share
			fi
			c_lcfile_dstpath="/usr/share"
		fi

		$c_sudo_command rm -rf $c_lcfile_dstpath/$c_lcfile_dstname
		$c_sudo_command mkdir $c_lcfile_dstpath/$c_lcfile_dstname

		$c_sudo_command cp -a $c_lcfile_srcpath/*.lc $c_lcfile_dstpath/$c_lcfile_dstname/
	}

	if [ $C_system = "rpm" ]; then
		C_install_process="C_FUNC_rpm_install_process"
		C_uninstall_command="rpm -e"
		C_script_path=$C_config_path_rpm
		C_sudo_command=""
	else
		C_install_process="C_FUNC_deb_install_process"
		C_uninstall_command="sudo dpkg -P"
		C_script_path=$C_config_path_deb
		C_sudo_command="sudo"
	fi

	## Common-Package install process ##
	$C_install_process $C_fpath_common $C_main_module
	if [ $? -ne 0 ]; then
		if [ $C_system = "deb" ]; then
			C_FUNC_show_and_exec "$C_uninstall_command $C_pkgname_common"
		fi
		exit
	fi
	
	C_pkgconfig_fname=$C_main_module-pkgconfig.sh
	C_pkgconfig_dname=${C_pkgconfig_fname%%\.sh}
	$C_pkgconfig_fname --pkgconfig 1> /dev/null 2>&1
	if [ $? -ne 0 ]; then
		C_FUNC_make_pkgconfig $C_pkgconfig_fname $C_script_path $C_sudo_command
		C_FUNC_copy_lcfile $C_local_path_inst $C_pkgconfig_dname $C_sudo_command
	else
		C_installed_config_ver=`$C_pkgconfig_fname --pkgconfig`
		C_FUNC_version_comp $C_installed_config_ver $C_version
		if [ $? -lt $C_equal ]; then
			$C_sudo_command rm -rf $C_script_path/$C_pkgconfig_fname
			C_FUNC_make_pkgconfig $C_pkgconfig_fname $C_script_path $C_sudo_command
			C_FUNC_copy_lcfile $C_local_path_inst $C_pkgconfig_dname $C_sudo_command
		fi
	fi
	
	$C_function01 "$L_INST_COM_01_04" "$C_system"

##########################################################
#### _ _ E x e c u t e _ P k g c o n f i g . s h  _ _ ####
##########################################################
else
	C_argment=$1

    #################################
	### Judge distribution system ###
    #################################
	C_FUNC_get_system
	if [ $? -ne 0 ]; then
		printf "$L_INST_COM_01_02"
		exit
	fi

    ################
	### Localize ###
    ################
	if [ $C_system = "rpm" ]; then
		C_local_path_pkgconf="/usr/local/share/${C_main_module}-pkgconfig"
	else
		C_local_path_pkgconf="/usr/share/${C_main_module}-pkgconfig"
	fi
	C_FUNC_localize "$C_local_path_pkgconf"

	## Check the argment ##
	if [ $# -ne 1 ]; then
		C_err=$C_err_usage
	elif [ $C_argment != "--version" ] && [ $C_argment != "--uninstall" ] && [ $C_argment != "--pkgconfig" ]; then
		C_err=$C_err_usage
	fi

	if [ $C_err = $C_err_usage ]; then
		printf "$L_INST_COM_02_01" "${0##*/} $C_arg_pkg"
		exit
	fi

	########################
	### Unistall process ###
	########################
	if [ $C_argment = "--uninstall" ]; then
	
		C_FUNC_rpm_uninstall_process()
		{
			rpm -q $1 1> /dev/null 2>&1
			## result -> 0:Package installed, 1:Package not installed ##
			if [ $? -eq 0 ]; then
				# uninstall #
				C_FUNC_show_and_exec "rpm -e $1"
				## result -> 0:Uninstall complete, 1:Uninstall error by debendency ##
				if [ $? -ne 0 ]; then
					# Dependency error #
					return $C_ERR_CODE
				fi
			fi
			return 0
		}

		C_FUNC_deb_uninstall_process()
		{
			# uninstall #
			C_FUNC_show_and_exec "sudo dpkg -P $1"
			## result -> 0:Uninstall complete, 1:Uninstall error by debendency ##
			if [ $? -ne 0 ]; then
				# Dependency error #
				return $C_ERR_CODE
			fi
			
			return 0
		}

		if [ $C_system = "rpm" ]; then
			C_uninstall_process="C_FUNC_rpm_uninstall_process"
			C_sudo_command=""
			
			##  Check permission by root ##
			if test `id -un` != "root"; then
				su -c "$0 $C_argment"
				exit
			fi
		else
			C_uninstall_process="C_FUNC_deb_uninstall_process"
			C_sudo_command="sudo"

			sudo echo > /dev/null
				if [ $? -ne 0 ]; then
				exit
			fi
		fi

		$C_function02 "$C_system"

		##  Delete mine (pkgconfig.sh)  ##
		$C_sudo_command rm -rf $(dirname $0)/${0##*/}

		C_pkgconfigsh=${0##*/}
		C_pkgconfig=${C_pkgconfigsh%%\.sh}
		if [ $C_system = "rpm" ]; then
			C_lcfile_path="/usr/local/share/${C_pkgconfig}"
		else
			C_lcfile_path="/usr/share/${C_pkgconfig}"
		fi
		$C_sudo_command rm -rf $C_lcfile_path
		
		##  Uninstall Common-Package ##
		$C_uninstall_process $C_main_module

		printf "$L_INST_COM_02_02"

	###############################
	### Version display process ###
	###############################
	elif [ $C_argment = "--version" ]; then

	    #########################
		### Judge 32bit/64bit ###
	    #########################
		 
		C_FUNC_get_bitconf version
		if [ $? -eq $C_ERR_CODE ]; then
			exit
		fi
				
		echo ; $C_function03 "${C_version%%-*}"
		printf "\n$L_INST_COM_03_01"
		
		if [ $C_system = "rpm" ]; then
			echo $C_main_module-$C_version.$C_arch.$C_system

		else
			echo ${C_main_module}_${C_version}_$C_arch.$C_system

		fi
		echo

	elif [ $C_argment = "--pkgconfig" ]; then
		echo $C_version
	fi

fi

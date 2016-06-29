dnl Copyright (c) 2016 Hewlett Packard Enterprise Development LP
dnl
dnl This program is free software: you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation, either version 3 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program.  If not, see <http://www.gnu.org/licenses/>.

define(`eucalyptus_domain_template',``
########################################
## <summary>
##	Execute a domain transition to run eucalyptus_$1.
## </summary>
## <param name="domain">
##	<summary>
##	Domain allowed to transition.
##	</summary>
## </param>
#
interface(`eucalyptus_domtrans_$1',`
    gen_require(`
        type eucalyptus_$1_t, eucalyptus_$1_exec_t;
    ')

    domtrans_pattern(dollarsone, eucalyptus_$1_exec_t, eucalyptus_$1_t)
')

########################################
## <summary>
##	Send generic signals to eucalyptus_$1 processes.
## </summary>
## <param name="domain">
##	<summary>
##	Domain allowed access.
##	</summary>
## </param>
#
interface(`eucalyptus_signal_$1',`
    gen_require(`
        type eucalyptus_$1_t;
    ')

    allow dollarsone eucalyptus_$1_t:process signal;
')

########################################
## <summary>
##	Send a null signal to eucalyptus_$1 processes.
## </summary>
## <param name="domain">
##	<summary>
##	Domain allowed access.
##	</summary>
## </param>
#
interface(`eucalyptus_signull_$1',`
    gen_require(`
        type eucalyptus_$1_t;
    ')

    allow dollarsone eucalyptus_$1_t:process signull;
')

########################################
## <summary>
##	Send SIGKILL to eucalyptus_$1 processes.
## </summary>
## <param name="domain">
##	<summary>
##	Domain allowed access.
##	</summary>
## </param>
#
interface(`eucalyptus_kill_$1',`
    gen_require(`
        type eucalyptus_$1_t;
    ')

    allow dollarsone eucalyptus_$1_t:process sigkill;
')

########################################
## <summary>
##	Execute eucalyptus_$1 in the eucalyptus_$1 domain.
## </summary>
## <param name="domain">
##	<summary>
##	Domain allowed to transition.
##	</summary>
## </param>
#
interface(`eucalyptus_systemctl_$1',`
    gen_require(`
        type eucalyptus_$1_unit_file_t;
        type eucalyptus_$1_t;
    ')

    allow dollarsone eucalyptus_$1_unit_file_t:file read_file_perms;
    allow dollarsone eucalyptus_$1_unit_file_t:service manage_service_perms;

    ps_process_pattern(dollarsone, eucalyptus_$1_t)

    init_reload_services(dollarsone)

    systemd_exec_systemctl(dollarsone)
    systemd_search_unit_dirs(dollarsone)

')
'')

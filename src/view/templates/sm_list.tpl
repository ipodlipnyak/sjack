{% extends theme %} {% block head %} {{ parent() }}
<style type="text/css">
</style>
{% endblock %} {% block content %}

<div class="box box-primary">
	<!-- box-body -->
	<div class="box-body no-padding">

		<table class="table table-hover">
			<thead>
				<tr>
					<th style="width: 40px">Статус</th>
					<th>Имя</th>
					<th style="width: 80px"></th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="site in sites_list">
					<td><span :class="css_status[site.status]" class="label">${ site.status }</span></td>
					<td><a v-if="site_on_edit != site.domain" :href="'/sm/list/' + site.domain">${ site.domain }</a>
						<input v-if="site_on_edit == site.domain" v-model="new_hostname" type="text" class="form-control input-sm">
						</td>

					<td>
						<div class="btn-group">
							<button v-if="site_on_edit == site.domain" type="button" v-on:click="save_site()"
								class="btn btn-success btn-sm" title=""
								data-original-title="Edit">
								<i class="fa fa-check"></i>
							</button>
							<button v-if="site_on_edit != site.domain" type="button" v-on:click="edit_site(site.domain)"
								class="btn btn-primary btn-sm" title=""
								data-original-title="Edit">
								<i class="fa fa-pen"></i>
							</button>
							
							<button v-if="site_on_edit == site.domain" type="button"
								v-on:click="cancel_site_edit(site.domain)"
								class="btn btn-danger btn-sm" title=""
								data-original-title="Cancel">
								<i class="fa fa-times"></i>
							</button>
							<button v-if="site_on_edit != site.domain" type="button"
								v-on:click="select_on_delete_site(site.domain)"
								class="btn btn-danger btn-sm" title=""
								data-original-title="Delete">
								<i class="fa fa-times"></i>
							</button>
						</div>
					</td>
				</tr>
			</tbody>
		</table>

	</div>
	<!-- /.box-body -->
</div>


<div id="modal-delete-confirmation" class="modal modal-warning fade"
	tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title">Вы уверены что хотите удалить сайт "${
					site_on_delete }"?</h4>
			</div>
			<div class="modal-body">
				<p v-if="site_on_delete">Все страницы с доменом "${ site_on_delete
					}" будут удалены</p>
			</div>
			<div class="modal-footer">
				<button v-on:click="do_not_delete_site()" type="button"
					class="btn btn-outline pull-left" data-dismiss="modal">Закрыть</button>
				<button v-on:click="delete_site()" type="button"
					class="btn btn-outline">Удалить</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->


{% endblock %} {% block footer %}
<script type="text/javascript" src="/assets/js/app_sm_list.js"></script>
{% endblock %}

{% extends theme %}

{% block head %}
    {{ parent() }}
    <style type="text/css">
        .pagination {}
        .page-item {}
        .sorting:after{
            opacity: 0.2;
            content: "\e150";
            font-family: 'Glyphicons Halflings';
            position: absolute;
            padding-left: 5px;
        }
        .sorting.desc:after{
            content: "\e156";
        }
        .sorting.asc:after{
            content: "\e155";
        }
        .sorting{
            cursor: pointer;
        }
        .table.datatable > thead > tr > th {
            padding-right: 30px;
        }
        .toolbox-info {
/*             padding-left: 300px; */
        }
        .toolbox-info input{
            max-width: 65px;
        }
        .title-max-width{
            width: 50%;
        }
        
        
    </style>
{% endblock %}

{% block content %}

<div class="box box-primary">
	<div class="box-header">
	
		<h3 class="box-title title-max-width">
			{{ domain }} <small>проверен {{ last_check_date }}</small>
			
		<div class='toolbox-info pull-right form-group form-inline'>
		<input id="pagin_max_el_input" v-model="pagin_max_el_input" step="1" min="1" :max="pages_list_count" type="number" class="form-control input-sm">
		<small>элементов отображено из ${ pages_list_count }</small>
		</div>
		</h3>
		<!-- tools box -->
		
  <paginate
  	v-model="pagination_num"
    :page-count="pagin_count"
	:page-range="3"
    :margin-pages="2"
    :prev-text="'<<'"
    :next-text="'>>'"
    :container-class="'pagination pull-right pagination-sm no-margin'"
    :page-class="'page-item'">
  </paginate>
		<!-- /. tools -->

	</div>
	<!-- /.box-header -->
	<!-- box-body -->
	<div class="box-body no-padding">
	
	<table class="table table-hover datatable">
				<thead>
				<tr>
				  <th style="width: 40px"></th>
                  <th v-on:click="toggle_sort('page_id')" :class="[pages_order_by == 'page_id' ? pages_order : '' ]" class='sorting' style="width: 10px">ID</span></th>
                  <th v-on:click="toggle_sort('http_status_code')" :class="[pages_order_by == 'http_status_code' ? pages_order : '' ]" class='sorting' style="width: 40px">Статус</th>
                  <th v-on:click="toggle_sort('protocol')" :class="[pages_order_by == 'protocol' ? pages_order : '' ]" class='sorting' style="width: 120px">Протокол</th>
                  <th v-on:click="toggle_sort('name')" :class="[pages_order_by == 'name' ? pages_order : '' ]" class='sorting' style="width: 120px">Имя</th>
                  <th v-on:click="toggle_sort('url')" :class="[pages_order_by == 'url' ? pages_order : '' ]" class='sorting'>URL</th>
                  <th style="width: 80px">
                  	<a v-on:click="toggle_search()" class="btn btn-sm"><i class="fa fa-search"></i></a>
                  </th>
                </tr>
                <tr v-if="show_filter == 1">
                <th></th>
                <th></th>
                <th><input type="text" v-model="filter_status" class="form-control input-sm"></th>
                <th></th>
                <th><input type="text" v-model="filter_name" class="form-control input-sm"></th>
                <th><input type="text" v-model="filter_url" class="form-control input-sm"></th>
                <th></th>
                </tr>
				</thead>
                <tbody>
                <tr v-for="page in pages_to_display">
				  <td>
                  <input v-model="pages_on_delete" :value="page.page_id" type="checkbox" class="">
                  </td>
                  <td>${ page.page_id }</td>
                  <td>
                  <span :class="css_status[page.status]" class="label">${ page.http_status_code }</span>
                  </td>
                  <td>
                  <span v-if="page_on_edit.page_id != page.page_id">${ page.protocol }://</span>
                  <input v-if="page_on_edit.page_id == page.page_id" v-model="page.protocol" type="text" class="form-control input-sm">
                  </td>
                  <td>
                  <span v-if="page_on_edit.page_id != page.page_id">${ page.name }</span>
                  <input v-if="page_on_edit.page_id == page.page_id" v-model="page.name" type="text" class="form-control input-sm">
                  </td>
                  <td>
                  <a v-if="page_on_edit.page_id != page.page_id" :href="page.protocol +'://'+ page.domain + page.url">${ page.url }</a>
                  <div v-if="page_on_edit.page_id == page.page_id" class="row">
                  <div class="col-xs-3">
                  <input v-model="page.domain" type="text" class="form-control input-sm">
                  </div>
                  <div class="col-xs-9">
                  <input v-model="page.url" type="text" class="form-control input-sm">
                  </div>
                  </div>
                  
                  </td>
                  
                  <td>
					<div class="btn-group">
							<button v-if="page_on_edit.page_id == page.page_id" type="button" v-on:click="save_page()"
								class="btn btn-success btn-sm" title=""
								data-original-title="Edit">
								<i class="fa fa-check"></i>
							</button>
							<button v-if="page_on_edit.page_id != page.page_id" type="button" v-on:click="edit_page(page)"
								class="btn btn-primary btn-sm" title=""
								data-original-title="Edit">
								<i class="fa fa-pen"></i>
							</button>
							
							<button v-if="page_on_edit.page_id == page.page_id" type="button"
								v-on:click="cancel_page_edit()"
								class="btn btn-danger btn-sm" title=""
								data-original-title="Cancel">
								<i class="fa fa-times"></i>
							</button>
							<button v-if="page_on_edit.page_id != page.page_id" type="button"
								v-on:click="page_on_delete(page.page_id)"
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
	<div class="box-footer">
	<button v-on:click="page_on_delete()" type="button" class="btn btn-danger btn-sm" title="" data-original-title="Remove">Удалить отмеченные страницы</button>
  <paginate
  	v-model="pagination_num"
    :page-count="pagin_count"
    :page-range="3"
    :margin-pages="2"
    :prev-text="'<<'"
    :next-text="'>>'"
    :container-class="'pagination pagination-sm no-margin pull-right'"
    :page-class="'page-item'">
  </paginate>
	</div>
	<!-- box-footer -->
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
				<h4 class="modal-title">${ delete_confirmation_title }</h4>
			</div>
			<div class="modal-body">
				<p>${ delete_confirmation_info }</p>
			</div>
			<div class="modal-footer">
				<button v-on:click="do_not_delete_pages()" type="button"
					class="btn btn-outline pull-left" data-dismiss="modal">Отменить</button>
				<button v-on:click="delete_pages()" type="button"
					class="btn btn-outline">Удалить</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->

{% endblock %}

{% block footer %}
	<script type="text/javascript">
	var sm_domain = '{{ domain }}';
	</script>
    <script type="text/javascript" src="/assets/js/app_sm_page.js"></script>
{% endblock %}
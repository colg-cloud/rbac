<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="/WEB-INF/jsp/common/head.jsp" %>
<style>
  .tree li {
    list-style-type: none;
    cursor: pointer;
  }

  table tbody tr:nth-child(odd) {
    background: #F4F4F4;
  }

  table tbody td:nth-child(even) {
    color: #C00;
  }
</style>
</head>

<body>

  <%--导航--%>
  <%@ include file="/WEB-INF/jsp/common/nav.jsp" %>

  <div class="container-fluid">
    <div class="row">
      <div class="col-sm-3 col-md-2 sidebar">
        <%--菜单--%>
        <%@ include file="/WEB-INF/jsp/common/menu.jsp" %>
      </div>
      <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
        <div class="panel panel-default">
          <div class="panel-heading">
            <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
          </div>
          <div class="panel-body">
            <form class="form-inline pull-left" role="form">
              <div class="form-group has-feedback">
                <div class="input-group">
                  <div class="input-group-addon">查询条件</div>
                  <input id="queryText" class="form-control has-success" type="text" placeholder="请输入查询条件">
                </div>
              </div>
              <button id="queryBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
            </form>
            <button type="button" class="btn btn-danger pull-right" style="margin-left:10px;" onclick="deleteUsers()">
              <i class=" glyphicon glyphicon-remove"></i> 删除
            </button>
            <button type="button" class="btn btn-primary pull-right" onclick="window.location.href='${applicationScope.APP_PATH}/user/add'">
              <i class="glyphicon glyphicon-plus"></i> 新增
            </button>
            <br>
            <hr style="clear:both;">
            <div class="table-responsive">
              <form id="userForm">
                <table class="table table-striped table-bordered table-hover">
                  <thead>
                    <tr>
                      <th width="50">序号</th>
                      <th width="30">
                        <label for="allSelBox">
                          <input type="checkbox" id="allSelBox">
                        </label>
                      </th>
                      <th>账号</th>
                      <th>名称</th>
                      <th>邮箱地址</th>
                      <th>创建时间</th>
                      <th>修改时间</th>
                      <th width="100">操作</th>
                    </tr>
                  </thead>

                  <tbody id="userData"></tbody>

                  <tfoot>
                    <tr>
                      <td colspan="8" align="center">
                        <ul class="pagination"></ul>
                      </td>
                    </tr>
                  </tfoot>
                </table>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    $(() => {
      $(".list-group-item").click(function () {
        if ($(this).find("ul")) {
          $(this).toggleClass("tree-closed")
          if ($(this).hasClass("tree-closed")) {
            $("ul", this).hide("fast")
          } else {
            $("ul", this).show("fast")
          }
        }
      })

      // 分页查询，默认从第一页开始查
      const startNum = 1
      pageQuery(startNum)

      // 查询
      $('#queryBtn').click(() => {
        const queryText = $('#queryText').val()
        pageQuery(startNum, queryText)
      })

      // 全选
      $('#allSelBox').click(function () {
        const self = this
        $('#userData :checkbox').each(function () {
          this.checked = self.checked
        })
      })
    })

    $("tbody .btn-success").click(() => {
      window.location.href = "assign${applicationScope.APP_PATH}/role/list"
    })
    $("tbody .btn-primary").click(() => {
      window.location.href = "edit.html"
    })

    // 分页查询
    const pageSize = 10

    // 分页查询
    function pageQuery(pageNum, loginacct) {
      let loadingIndex = null
      $.ajax({
        type: 'post',
        url: '${applicationScope.APP_PATH}/user/pageQuery',
        data: {pageNum, pageSize, loginacct},
        beforeSend: () => {
          loadingIndex = layer.msg('处理中', {icon: 16})
        },
        success: data => {
          layer.close(loadingIndex)

          const {data: userList, total: totalSize} = data
          let totalPage = Math.ceil(totalSize / pageSize)

          // 局部刷新页面数据
          // 表格
          let tableContext = ''
          $.each(userList, (index, user) => {
            const {id, loginacct, username, email, createTime, updateTime} = user

            tableContext += '<tr>'
            tableContext += '   <td>' + (index + 1) + '</td>'
            tableContext += '   <td><input type="checkbox" name="id" value="' + user.id + '"></td>'
            tableContext += '   <td>' + loginacct + '</td>'
            tableContext += '   <td>' + username + '</td>'
            tableContext += '   <td>' + email + '</td>'
            tableContext += '   <td>' + createTime + '</td>'
            tableContext += '   <td>' + updateTime + '</td>'
            tableContext += '   <td>'
            tableContext += '       <button type="button" onclick=\'goAssignPage("' + id + '")\'" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>'
            tableContext += '       <button type="button" onclick=\'goUpbatePage("' + id + '")\'" class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>'
            tableContext += '       <button type="button" onclick=\'delUser("' + id + '")\'" class="btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>'
            tableContext += '   </td>'
            tableContext += '</tr>'
          })
          $('#userData').html(tableContext)

          // 分页
          let paginationContext = ''
          if (pageNum <= 1) {
            paginationContext += '<li class="disabled"><a href="#">上一页</a></li>'
          } else {
            paginationContext += '<li><a href="#" onclick="pageQuery(' + (pageNum - 1) + ')">上一页</a></li>'
          }

          for (let i = 1; i <= totalPage; i++) {
            if (i === pageNum) {
              paginationContext += '<li class="active"><a href="#">' + i + '<span class="sr-only">(current)</span></a></li>'
            } else {
              paginationContext += '<li><a href="#" onclick="pageQuery(' + i + ')">' + i + '</a></li>'
            }
          }

          if (pageNum < totalPage) {
            paginationContext += '<li><a href="#" onclick="pageQuery(' + (pageNum + 1) + ')">下一页</a></li>'
          } else {
            paginationContext += '<li class="disabled"><a href="#">下一页</a></li>'
          }
          $('.pagination').html(paginationContext)
        }
      })
    }

    // 跳转编辑页面
    function goUpbatePage(id) {
      window.location.href = '${applicationScope.APP_PATH}/user/edit?id=' + id
    }

    // 跳转分配角色页面
    function goAssignPage(id) {
      window.location.href = '${applicationScope.APP_PATH}/user/assign?id=' + id
    }

    // 批量删除用户
    function deleteUsers() {
      /*
      let ids = []
      $('#userData :checkbox').each(function () {
          if (this.checked) {
              ids.push($(this).val())
          }
      })
      ids = ids.join(',')
      */

      let boxes = $('#userData :checkbox')
      if (boxes.length === 0) {
        layer.msg('请选择需要删除的用户信息', {time: 1000, icon: 5, shift: 6})
      } else {
        layer.confirm('删除用户信息, 是否继续?', {icon: 3, title: '提示'}, cindex => {
          layer.close(cindex)
          let loadingIndex = null
          $.ajax({
            type: 'post',
            url: '${applicationScope.APP_PATH}/user/delUsers',
            data: $('#userForm').serialize(),
            beforeSend: () => {
              loadingIndex = layer.msg('处理中', {icon: 16})
            },
            success: data => {
              layer.close(loadingIndex);
              if (data.code === 0) {
                layer.msg('用户信息删除成功', {time: 1000, icon: 6, shift: 5}, () => {
                  window.location.href = '${applicationScope.APP_PATH}/user/list'
                })
              } else {
                layer.msg(data.message, {time: 1000, icon: 5, shift: 6})
              }
            }
          })
        }, function (cindex) {
          layer.close(cindex)
        })
      }
    }

    // 删除用户
    function delUser(id) {
      layer.confirm('删除用户信息, 是否继续?', {icon: 3, title: '提示'}, cindex => {
        layer.close(cindex)
        let loadingIndex = null
        $.ajax({
          type: 'post',
          url: '${applicationScope.APP_PATH}/user/delUser',
          data: {id},
          beforeSend: () => {
            loadingIndex = layer.msg('处理中', {icon: 16})
          },
          success: data => {
            layer.close(loadingIndex);
            if (data.code === 0) {
              layer.msg('用户信息删除成功', {time: 1000, icon: 6, shift: 5}, () => {
                window.location.href = '${applicationScope.APP_PATH}/user/list'
              })
            } else {
              layer.msg(data.message, {time: 1000, icon: 5, shift: 6})
            }
          }
        })
      }, cindex => {
        layer.close(cindex)
      })
    }
  </script>
</body>
</html>

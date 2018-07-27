package cn.colg.rbac.dto;

import cn.colg.rbac.entity.Permission;
import com.alibaba.fastjson.annotation.JSONField;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * @author colg
 */
@Getter
@Setter
public class PermissionDto extends Permission {

    /**
     * 记录 treeNode 节点的 展开 / 折叠 状态。
     * true 表示节点为 展开 状态
     * false 表示节点为 折叠 状态
     */
    private boolean open = true;
    /**
     * 节点的 checkBox / radio 的 勾选状态。
     * true 表示节点的输入框被勾选
     * false 表示节点的输入框未勾选
     */
    private boolean checked = false;

    /**
     * 子节点
     */
    @JSONField(ordinal = 1)
    private List<PermissionDto> children = new ArrayList<>();

}

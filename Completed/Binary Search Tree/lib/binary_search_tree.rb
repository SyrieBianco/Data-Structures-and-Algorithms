# There are many ways to implement these methods, feel free to add arguments
# to methods as you see fit, or to create helper methods.
require_relative 'bst_node'

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end


  def insert(value)
    new_node = BSTNode.new(value)
    if @root.nil?
      @root = new_node
    else
      find_and_append(new_node)
    end

  end


  def find(value, tree_node = @root)
    case value <=> tree_node.value
    when 0
      tree_node
    when -1
      return nil unless tree_node.left
      find(value, tree_node.left)
    else
      return nil unless tree_node.right
      find(value, tree_node.right)
    end
  end


  def delete(value)
    target = find(value)
    parent = target.parent

    case target.children.length
      # if the target has no children...
    when 0
      # reset the root to nil if it is the root (doesn't have a parent)
      return @root = nil if parent.nil?
      # remove the parent's left or right pointer appropriately
      target.less_than?(parent) ? parent.left = nil : parent.right = nil

    when 1
      target.children[0].append_to(parent)

    when 2
      # find replacement node
      replacement = maximum(target.left)

      # re-assign its child to its parent
      replacement.left.append_to(replacement.parent)

      replacement.replace(target)
    end

  end


  def maximum(tree_node = @root)
    # base case
    return tree_node unless tree_node.right

    maximum(tree_node.right)
  end


  def depth(tree_node = @root)
    return 0 unless tree_node
    return 0 if tree_node.children.empty?

    depths = [depth(tree_node.left), depth(tree_node.right)]
    max_depth = depths.max

    max_depth + 1
  end


  def is_balanced?(tree_node = @root)
    return true if depth(tree_node) < 2

    left, right = tree_node.left, tree_node.right

    return false if (depth(left) - depth(right)).abs > 1

    is_balanced?(left) && is_balanced?(right)
  end

  def in_order_traversal(tree_node = @root, arr = [])
    return [tree_node.value] unless tree_node.children

    left_sub, right_sub = tree_node.left, tree_node.right
    left_arr, right_arr = [], []

    left_arr.concat(in_order_traversal(left_sub)) if left_sub
    right_arr.concat(in_order_traversal(right_sub)) if right_sub

    left_arr + [tree_node.value] + right_arr
  end


  private
  # optional helper methods go here:
  def find_and_append(new_node, current_node = @root)
    case new_node.less_than?(current_node)
    when true

      if current_node.left
        find_and_append(new_node, current_node.left)
      else
        new_node.append_to(current_node)
      end

    else
      if current_node.right
        find_and_append(new_node, current_node.right)
      else
        new_node.append_to(current_node)
      end
    end
  end




end
